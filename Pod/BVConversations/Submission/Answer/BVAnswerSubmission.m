//
//  AnswerSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerSubmission.h"
#import "BVUploadablePhoto.h"
#import "BVAnswerSubmissionErrorResponse.h"
#import "BVSDKManager.h"
#import "BVConversationsAnalyticsUtil.h"
#import "BVCore.h"

@interface BVAnswerSubmission()

@property (readwrite) NSString* _Nonnull questionId;
@property NSString* _Nonnull answerText;
@property NSMutableArray<BVUploadablePhoto*>* _Nonnull photos;
@property bool failureCalled;

@end

@implementation BVAnswerSubmission

-(nonnull instancetype)initWithQuestionId:(nonnull NSString*)questionId answerText:(nonnull NSString*)answerText {
    self = [super init];
    if(self){
        self.questionId = questionId;
        self.answerText = answerText;
        self.photos = [NSMutableArray array];
    }
    return self;
}

-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption {
    BVUploadablePhoto* photo = [[BVUploadablePhoto alloc] initWithPhoto:image photoCaption:photoCaption];
    [self.photos addObject:photo];
}

-(void)submit:(nonnull AnswerSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure {
    
    [BVConversationsAnalyticsUtil queueAnalyticsEventForAnswerSubmission:self];
    
    if (self.action == BVSubmissionActionPreview) {
        //TODO send off warning that this doesn't actually submit shtuff
        [[BVLogger sharedLogger] warning:@"Submitting a 'BVAnswerSubmission' with action set to `BVSubmissionActionPreview` will not actially submit the answer! Set to `BVSubmissionActionSubmit` for real submission."];
        [self submitPreview:success failure:failure];
    }
    else {
        [self submitPreview:^(BVAnswerSubmissionResponse * _Nonnull response) {
            [self submitForReal:success failure:failure];
        } failure:^(NSArray<NSError *> * _Nonnull errors) {
            [self sendErrors:errors failureCallback:failure];
        }];
    }
}

-(void)submitPreview:(AnswerSubmissionCompletion)success failure:(ConversationsFailureHandler)failure {
    
    [self submitAnswerWithPhotoUrls:BVSubmissionActionPreview
                          photoUrls:@[]
                      photoCaptions:@[]
                            success:success
                            failure:failure];
    
}

-(void)submitForReal:(AnswerSubmissionCompletion)success failure:(ConversationsFailureHandler)failure {
    
    if ([self.photos count] == 0) {
        [self submitAnswerWithPhotoUrls:BVSubmissionActionSubmit
                              photoUrls:@[]
                          photoCaptions:@[]
                                success:success
                                failure:failure];
        return;
    }
    
    // upload photos before submitting Answer
    NSMutableArray<NSString*>* photoUrls = [NSMutableArray array];
    NSMutableArray<NSString*>* photoCaptions = [NSMutableArray array];
    
    for (BVUploadablePhoto* photo in self.photos) {
        
        [photo uploadForContentType:BVPhotoContentTypeAnswer success:^(NSString * _Nonnull photoUrl) {
            
            [photoUrls addObject:photoUrl];
            [photoCaptions addObject:photo.photoCaption];
            
            // all photos uploaded! submit answer
            if ([photoUrls count] == [self.photos count]) {
                [self submitAnswerWithPhotoUrls:BVSubmissionActionSubmit
                                      photoUrls:photoUrls
                                  photoCaptions:photoCaptions
                                        success:success
                                        failure:failure];
            }
            
        } failure:^(NSArray<NSError *> * _Nonnull errors) {
            
            if (!self.failureCalled) {
                self.failureCalled = true; // only call failure block once, if multiple photos failed.
                [self sendErrors:errors failureCallback:failure];
            }
            
        }];
        
    }
    
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

-(void)submitAnswerWithPhotoUrls:(BVSubmissionAction)BVSubmissionAction photoUrls:(nonnull NSArray<NSString*>*)photoUrls photoCaptions:(nonnull NSArray<NSString*>*)photoCaptions success:(nonnull AnswerSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure {
    
    
    NSDictionary* parameters = [self createSubmissionParameters:BVSubmissionAction photoUrls:photoUrls photoCaptions:photoCaptions];
    NSData* postBody = [self transformToPostBody:parameters];
    
    NSString* urlString = [NSString stringWithFormat:@"%@submitanswer.json", [BVConversationsRequest commonEndpoint]];
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
            BVAnswerSubmissionErrorResponse* errorResponse = [[BVAnswerSubmissionErrorResponse alloc] initWithApiResponse:json]; // fails gracefully
        
            [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json, (long)statusCode]];
            
            if (httpError) {
                // network error was generated
                [self sendError:httpError failureCallback:failure];
            }
            else if(statusCode >= 300){
                // HTTP status code indicates failure
                NSError* statusError = [NSError errorWithDomain:@"com.bazaarvoice.bvsdk" code:BV_ERROR_NETWORK_FAILED userInfo:@{NSLocalizedDescriptionKey:@"Photo upload failed."}];
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
                BVAnswerSubmissionResponse* response = [[BVAnswerSubmissionResponse alloc] initWithApiResponse:json];
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

-(nonnull NSDictionary*)createSubmissionParameters:(BVSubmissionAction)BVSubmissionAction photoUrls:(nonnull NSArray<NSString*>*)photoUrls photoCaptions:(nonnull NSArray<NSString*>*)photoCaptions {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                          @"apiversion": @"5.4",
                                          @"answertext": self.answerText,
                                          @"questionid": self.questionId,
                                      }];
    
    parameters[@"passkey"] = [BVSDKManager sharedManager].apiKeyConversations;
    parameters[@"action"] = [BVSubmissionActionUtil toString:self.action];
    
    parameters[@"campaignid"] = self.campaignId;
    parameters[@"locale"] = self.locale;
    
    parameters[@"hostedauthentication_authenticationemail"] = self.hostedAuthenticationEmail;
    parameters[@"hostedauthentication_callbackurl"] = self.hostedAuthenticationCallback;
    parameters[@"fp"] = self.fingerPrint;
    parameters[@"user"] = self.user;
    parameters[@"usernickname"] = self.userNickname;
    parameters[@"useremail"] = self.userEmail;
    parameters[@"userid"] = self.userId;
    parameters[@"userlocation"] = self.userLocation;
    
    int photoIndex = 0;
    for(NSString* url in photoUrls) {
        NSString* key = [NSString stringWithFormat:@"photourl_%i", photoIndex];
        parameters[key] = url;
        photoIndex += 1;
    }
    
    int captionIndex = 0;
    for(NSString* caption in photoCaptions) {
        NSString* key = [NSString stringWithFormat:@"photocaption_%i", captionIndex];
        parameters[key] = caption;
        captionIndex += 1;
    }
    
    if (self.sendEmailAlertWhenPublished) {
        parameters[@"sendemailalertwhenpublished"] = [self.sendEmailAlertWhenPublished boolValue] ? @"true" : @"false";
    }
    
    if (self.agreedToTermsAndConditions) {
        parameters[@"agreedtotermsandconditions"] = [self.agreedToTermsAndConditions boolValue] ? @"true" : @"false";
    }
    
    return parameters;
    
}

@end
