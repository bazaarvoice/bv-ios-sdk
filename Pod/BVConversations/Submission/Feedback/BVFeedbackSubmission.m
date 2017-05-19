//
//  BVFeedbackSubmission.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFeedbackSubmission.h"
#import "BVSDKManager.h"
#import "BVSDKConfiguration.h"

@implementation BVFeedbackSubmission

-(nonnull instancetype)initWithContentId:(nonnull NSString*)contentId
                          withContentType:(BVFeedbackContentType)contentType
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
                
                [self trackFeedbackEvent];

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

- (void)trackFeedbackEvent {

    // Fire event now that we've confirmed the answer was successfully uploaded.
    BVPixelImpressionContentType contentType = BVPixelImpressionContentTypeReview;
    BVPixelProductType productTypeForEvent = BVPixelProductTypeConversationsReviews;
    if (self.contentType == BVFeedbackContentTypeReview){
        contentType = BVPixelImpressionContentTypeReview;
        productTypeForEvent = BVPixelProductTypeConversationsReviews;
    } else if (self.contentType == BVFeedbackContentTypeQuestion){
        contentType = BVPixelImpressionContentTypeQuestion;
        productTypeForEvent = BVPixelProductTypeConversationsQuestionAnswer;
    } else if (self.contentType == BVFeedbackContentTypeAnswer){
        contentType = BVPixelImpressionContentTypeAnswer;
        productTypeForEvent = BVPixelProductTypeConversationsQuestionAnswer;
    }
    
    BVPixelFeatureUsedEventName featureUsed = BVPixelFeatureUsedEventNameFeedback;
    NSString *detail1 = @"";
    if (self.feedbackType == BVFeedbackTypeHelpfulness){
        featureUsed = BVPixelFeatureUsedEventNameFeedback;
        if (self.vote == BVFeedbackVotePositive){
            detail1 = @"Positive";
        } else if (self.vote == BVFeedbackVoteNegative){
            detail1 = @"Negative";
        }

    } else if (self.feedbackType == BVFeedbackTypeInappropriate){
        featureUsed = BVPixelFeatureUsedEventNameInappropriate;
        detail1 = @"Inappropriate";
    }
    
    NSDictionary *additionalParams = @{@"contentType":[BVPixelImpressionContentTypeUtil toString:contentType],
                                       @"contentId":self.contentId,
                                       @"detail1":detail1};
    
    BVFeatureUsedEvent *feedbackEvent = [[BVFeatureUsedEvent alloc] initWithProductId:self.contentId
                                                                            withBrand:nil
                                                               withProductType:productTypeForEvent
                                                                  withEventName:featureUsed
                                                                 withAdditionalParams:additionalParams];
    
    [BVPixel trackEvent:feedbackEvent];
    
    
}

-(nonnull NSDictionary*)createSubmissionParameters {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:@{ @"apiversion": @"5.4" }];
    
    parameters[@"passkey"] = [BVSDKManager sharedManager].configuration.apiKeyConversations;
    parameters[@"userid"] = self.userId;
    parameters[@"contentId"] = self.contentId;
    
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
