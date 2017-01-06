//
//  BVFeedbackSubmission.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFeedbackSubmission.h"
#import "BVSDKManager.h"
#import "BVConversationsAnalyticsUtil.h"

@implementation BVFeedbackSubmission

-(nonnull instancetype)initWithContentId:(nonnull NSString*)contentId
                          withConentType:(BVFeedbackContentType)contentType
                        withFeedbackType:(BVFeedbackType)feedbackType{
    
    self = [super init];
    if(self){
        self.contentId = contentId;
        self.feedbackType = feedbackType;
        self.contentType = contentType;
    }
    return self;
    
}

-(void)submit:(nonnull FeedbackSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure{
    
    [self submitFeedbackWithCompletion:^(BVFeedbackSubmissionResponse * _Nonnull response) {
        success(response);
    } failure:^(NSArray<NSError *> * _Nonnull errors) {
        failure(errors);
    }];
    
}

-(void)submitFeedbackWithCompletion:(nonnull FeedbackSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure {
    
    NSDictionary* parameters = [self createSubmissionParameters];
    NSData* postBody = [self transformToPostBody:parameters];
    
    NSString* urlString = [NSString stringWithFormat:@"%@submitfeedback.json", [BVConversationsRequest commonEndpoint]];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postBody];
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"POST: %@\n with BODY: %@", urlString, parameters]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *httpError) {
        
        @try {
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response; // This dataTask is used with only HTTP requests.
            NSInteger statusCode = httpResponse.statusCode;
            NSError* jsonParsingError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
            BVSubmissionErrorResponse* errorResponse = [[BVSubmissionErrorResponse alloc] initWithApiResponse:json]; // fails gracefully
            
            [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json, (long)statusCode]];
            
            if (httpError) {
                // network error was generated
                [self sendError:httpError failureCallback:failure];
            }
            else if(statusCode >= 300){
                // HTTP status code indicates failure
                NSError* statusError = [NSError errorWithDomain:@"com.bazaarvoice.bvsdk" code:BV_ERROR_NETWORK_FAILED userInfo:@{NSLocalizedDescriptionKey:@"Feedback submission failed."}];
                [self sendError:statusError failureCallback:failure];
            }
            else if (jsonParsingError) {
                // json parsing failed
                [self sendError:jsonParsingError failureCallback:failure];
            }
            else if(errorResponse){
                // api returned successfully, but has bazaarvoice-specific errors. Example: 'invalid api key'
                [self sendErrors:[errorResponse toNSErrors] failureCallback:failure];
            }
            else {
                // success!
                
                 [BVConversationsAnalyticsUtil queueAnalyticsEventForFeedbackSubmission:self];
                
                BVFeedbackSubmissionResponse* response = [[BVFeedbackSubmissionResponse alloc] initWithApiResponse:json];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(response);
                });
            }
            
        }
        @catch (NSException *exception) {
            NSError* unknownError = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_UNKNOWN userInfo:@{NSLocalizedDescriptionKey:@"An unknown parsing error occurred."}];
            [self sendError:unknownError failureCallback:failure];
        }
        
    }];
    
    // start uploading answer
    [postDataTask resume];
    
}

-(NSData*)transformToPostBody:(NSDictionary*)dict {
    
    NSMutableArray *queryItems = [NSMutableArray array];
    
    for (NSString *key in dict) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:dict[key]]];
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://bazaarvoice.com"];
    components.queryItems = queryItems;
    NSString* query = components.query;
    return [query dataUsingEncoding:NSUTF8StringEncoding];
    
}

-(nonnull NSDictionary*)createSubmissionParameters {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:@{ @"apiversion": @"5.4" }];
    
    parameters[@"passkey"] = [BVSDKManager sharedManager].apiKeyConversations;
    parameters[@"userid"] = self.userId;
    parameters[@"contentId"] = self.contentId;
    
    self.contentType = 0;
    
    // Set the content type
    if (self.contentType == BVFeedbackContentTypeReview){
        parameters[@"contentType"] = @"review";
    } else if (self.contentType == BVFeedbackContentTypeAnswer){
        parameters[@"contentType"] = @"answer";
    } else if (self.contentType == BVFeedbackContentTypeQuestion){
        parameters[@"contentType"] = @"question";
    }
    
    if (self.feedbackType == BVFeedbackTypeHelpfulness){
        parameters[@"feedbackType"] = @"helpfulness";
        if (self.vote == BVFeedbackVotePositive){
            parameters[@"vote"] = @"positive";
        } else if (self.vote == BVFeedbackVoteNegative){
            parameters[@"vote"] = @"negative";
        }
    } else if (self.feedbackType == BVFeedbackTypeInappropriate) {
        parameters[@"feedbackType"] = @"inappropriate";
    }
    
    if (self.reasonText){
        parameters[@"reasonText"] = self.reasonText;
    }
    

    return parameters;
}

@end
