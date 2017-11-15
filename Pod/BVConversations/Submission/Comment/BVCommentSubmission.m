//
//  BVCommentSubmission.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentSubmission.h"
#import "BVSDKConfiguration.h"
#import "BVSubmissionErrorResponse.h"
#import "BVCommentSubmissionErrorResponse.h"
#import "BVUploadablePhoto.h"

@interface BVCommentSubmission ()

@property BOOL failureCalled;

@end


@implementation BVCommentSubmission

- (nonnull instancetype)initWithReviewId:(NSString *)reviewId withCommentText:(NSString *)commentText {
    
    self = [super init];
    
    if (self){
        _reviewId = reviewId;
        _commentText = commentText;
    }
    
    return self;
}


-(void)submit:(nonnull CommentSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure {
    
    if (self.action == BVSubmissionActionPreview) {
        [[BVLogger sharedLogger] warning:@"Submitting a 'BVCommentSubmission' with action set to `BVSubmissionActionPreview` will not actially submit the comment! Set to `BVSubmissionActionSubmit` for real submission."];
        [self submitPreview:success failure:failure];
    }
    else {
        [self submitPreview:^(BVCommentSubmissionResponse * _Nonnull response) {
            [self submitForReal:success failure:failure];
        } failure:^(NSArray<NSError *> * _Nonnull errors) {
            [self sendErrors:errors failureCallback:failure];
        }];
    }
}

-(void)submitPreview:(CommentSubmissionCompletion)success failure:(ConversationsFailureHandler)failure {
    
    [self submitCommentWithPhotoUrls:BVSubmissionActionPreview
                          photoUrls:@[]
                      photoCaptions:@[]
                            success:success
                            failure:failure];
    
}

-(void)submitForReal:(CommentSubmissionCompletion)success failure:(ConversationsFailureHandler)failure {
    
    if ([self.photos count] == 0) {
        [self submitCommentWithPhotoUrls:BVSubmissionActionSubmit
                              photoUrls:@[]
                          photoCaptions:@[]
                                success:success
                                failure:failure];
        return;
    }
    
    // upload photos before submitting comments (prr only)
    NSMutableArray<NSString*>* photoUrls = [NSMutableArray array];
    NSMutableArray<NSString*>* photoCaptions = [NSMutableArray array];
    
    for (BVUploadablePhoto* photo in self.photos) {
        
        [photo uploadForContentType:BVPhotoContentTypeComment success:^(NSString * _Nonnull photoUrl) {
            
            // Queue one event for each photo uploaded.
            BVFeatureUsedEvent *photoUploadEvent = [[BVFeatureUsedEvent alloc] initWithProductId:self.reviewId
                                                                                       withBrand:nil
                                                                                 withProductType:BVPixelProductTypeConversationsReviews
                                                                                   withEventName:BVPixelFeatureUsedEventNamePhoto
                                                                            withAdditionalParams:@{@"detail1":@"Comment"}];
            [BVPixel trackEvent:photoUploadEvent];
            
            
            [photoUrls addObject:photoUrl];
            [photoCaptions addObject:photo.photoCaption];
            
            // all photos uploaded! submit comment
            if ([photoUrls count] == [self.photos count]) {
                [self submitCommentWithPhotoUrls:BVSubmissionActionSubmit
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

-(void)submitCommentWithPhotoUrls:(BVSubmissionAction)action photoUrls:(nonnull NSArray<NSString*>*)photoUrls photoCaptions:(nonnull NSArray<NSString*>*)photoCaptions success:(nonnull CommentSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure {
    
    
    NSDictionary* parameters = [self createSubmissionParameters:action photoUrls:photoUrls photoCaptions:photoCaptions];
    NSData* postBody = [self transformToPostBody:parameters];
    
    NSString* urlString = [NSString stringWithFormat:@"%@submitreviewcomment.json", [BVConversationsRequest commonEndpoint]];
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
            BVCommentSubmissionErrorResponse* errorResponse = [[BVCommentSubmissionErrorResponse alloc] initWithApiResponse:json]; // fails gracefully
            
            [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json, (long)statusCode]];
            
            if (httpError) {
                // network error was generated
                [self sendError:httpError failureCallback:failure];
            }
            else if(statusCode >= 300){
                // HTTP status code indicates failure
                NSError* statusError = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_NETWORK_FAILED userInfo:@{NSLocalizedDescriptionKey:@"Photo upload failed."}];
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
                
                // Fire event now that we've confirmed the comment was successfully uploaded.
                BVFeatureUsedEvent *commentQuestionEvent = [[BVFeatureUsedEvent alloc] initWithProductId:self.reviewId
                                                                                              withBrand:nil
                                                                                        withProductType:BVPixelProductTypeConversationsReviews
                                                                                          withEventName:BVPixelFeatureUsedEventNameReviewComment
                                                                                   withAdditionalParams:nil];
                
                [BVPixel trackEvent:commentQuestionEvent];
                
                BVCommentSubmissionResponse* response = [[BVCommentSubmissionResponse alloc] initWithApiResponse:json];
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
    
    // start uploading comment
    [postDataTask resume];
    
}


-(nonnull NSDictionary*)createSubmissionParameters:(BVSubmissionAction)action photoUrls:(nonnull NSArray<NSString*>*)photoUrls photoCaptions:(nonnull NSArray<NSString*>*)photoCaptions {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"apiversion": @"5.4",
                                                                                      @"commenttext": _commentText,
                                                                                      @"reviewid": _reviewId,
                                                                                      }];
    
    parameters[@"passkey"] = [BVSDKManager sharedManager].configuration.apiKeyConversations;
    parameters[@"action"] = [BVSubmissionActionUtil toString:action];
    
    parameters[@"campaignid"] = self.campaignId;
    parameters[@"locale"] = self.locale;
    
    parameters[@"title"] = self.commentTitle;
    
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
    
    for (BVStringKeyValuePair* keyValuePair in self.customFormPairs) {
        NSString* key = [keyValuePair key];
        NSString* value = [keyValuePair value];
        parameters[key] = value;
    }
    
    return parameters;
    
}


@end
