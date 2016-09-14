//
//  ReviewSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewSubmission.h"
#import "BVReviewSubmissionErrorResponse.h"
#import "BVSDKManager.h"
#import "BVConversationsAnalyticsUtil.h"

@interface BVReviewSubmission()

@property NSUInteger rating;
@property NSString* _Nonnull reviewText;
@property NSString* _Nonnull reviewTitle;
@property (readwrite) NSString* _Nonnull productId;

@property NSMutableDictionary* _Nonnull additionalFields;
@property NSMutableDictionary* _Nonnull contextDataValues;
@property NSMutableDictionary* _Nonnull ratingQuestions;
@property NSMutableDictionary* _Nonnull ratingSliders;
@property NSMutableDictionary* _Nonnull predefinedTags;
@property NSMutableDictionary* _Nonnull freeformTags;

@property bool failureCalled;

@end

@implementation BVReviewSubmission

-(nonnull instancetype)initWithReviewTitle:(nonnull NSString*)reviewTitle reviewText:(nonnull NSString*)reviewText rating:(NSUInteger)rating productId:(nonnull NSString*)productId {
    self = [super init];
    if(self){
        self.reviewTitle = reviewTitle;
        self.reviewText = reviewText;
        self.rating = rating;
        self.productId = productId;
        self.photos = [NSMutableArray array];
        
        self.additionalFields = [NSMutableDictionary dictionary];
        self.contextDataValues = [NSMutableDictionary dictionary];
        self.ratingQuestions = [NSMutableDictionary dictionary];
        self.ratingSliders = [NSMutableDictionary dictionary];
        self.predefinedTags = [NSMutableDictionary dictionary];
        self.freeformTags = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption {
    BVUploadablePhoto* photo = [[BVUploadablePhoto alloc] initWithPhoto:image photoCaption:photoCaption];
    [self.photos addObject:photo];
}


/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#additional-field
-(void)addAdditionalField:(nonnull NSString*)fieldName value:(nonnull NSString*)value {
    NSString* key = [NSString stringWithFormat:@"additionalfield_%@", fieldName];
    self.additionalFields[key] = value;
}


/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#context-data-question
-(void)addContextDataValueString:(nonnull NSString*)contextDataValueName value:(nonnull NSString*)value {
    NSString* key = [NSString stringWithFormat:@"contextdatavalue_%@", contextDataValueName];
    self.contextDataValues[key] = value;
}


/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#context-data-question
-(void)addContextDataValueBool:(nonnull NSString*)contextDataValueName value:(bool)value {
    NSString* key = [NSString stringWithFormat:@"contextdatavalue_%@", contextDataValueName];
    self.contextDataValues[key] = value ? @"true" : @"false";
}


/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#rating-question---normal
-(void)addRatingQuestion:(nonnull NSString*)ratingQuestionName value:(int)value {
    NSString* key = [NSString stringWithFormat:@"rating_%@", ratingQuestionName];
    NSString* valueAsString = [NSString stringWithFormat:@"%i", value];
    self.ratingQuestions[key] = valueAsString;
}


/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#rating-question---slider
-(void)addRatingSlider:(nonnull NSString*)ratingQuestionName value:(nonnull NSString*)value {
    NSString* key = [NSString stringWithFormat:@"rating_%@", ratingQuestionName];
    self.ratingSliders[key] = value;
}


/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#tags---tag-dimensions
-(void)addPredefinedTagDimension:(nonnull NSString*)tagQuestionId tagId:(nonnull NSString*)tagId value:(nonnull NSString*)value {
    NSString* key = [NSString stringWithFormat:@"tagid_%@/%@", tagQuestionId, tagId];
    self.predefinedTags[key] = value;
}


/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#tags---tag-dimensions
-(void)addFreeformTagDimension:(nonnull NSString*)tagQuestionId tagNumber:(int)tagNumber value:(nonnull NSString*)value {
    NSString* key = [NSString stringWithFormat:@"tag_%@_%i", tagQuestionId, tagNumber];
    self.freeformTags[key] = value;
}


-(void)submit:(nonnull ReviewSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure {
    
    [BVConversationsAnalyticsUtil queueAnalyticsEventForReviewSubmission:self];
    
    if (self.action == BVSubmissionActionPreview) {
        [[BVLogger sharedLogger] warning:@"Submitting a 'BVReviewSubmission' with action set to `BVSubmissionActionPreview` will not actially submit the review! Set to `BVSubmissionActionSubmit` for real submission."];
        [self submitPreview:success failure:failure];
    }
    else {
        [self submitPreview:^(BVReviewSubmissionResponse * _Nonnull response) {
            [self submitForReal:success failure:failure];
        } failure:^(NSArray<NSError *> * _Nonnull errors) {
            [[BVLogger sharedLogger] printErrors:errors];
            failure(errors);
        }];
    }
}

-(void)submitPreview:(ReviewSubmissionCompletion)success failure:(ConversationsFailureHandler)failure {
    
    [self submitReviewWithPhotoUrls:BVSubmissionActionPreview
                          photoUrls:@[]
                      photoCaptions:@[]
                            success:success
                            failure:failure];
    
}

-(void)submitForReal:(ReviewSubmissionCompletion)success failure:(ConversationsFailureHandler)failure {
    
    if ([self.photos count] == 0) {
        [self submitReviewWithPhotoUrls:BVSubmissionActionSubmit
                              photoUrls:@[]
                          photoCaptions:@[]
                                success:success
                                failure:failure];
        return;
    }
    
    // upload photos before submitting content
    NSMutableArray<NSString*>* photoUrls = [NSMutableArray array];
    NSMutableArray<NSString*>* photoCaptions = [NSMutableArray array];
    
    for (BVUploadablePhoto* photo in self.photos) {
        
        [photo uploadForContentType:BVPhotoContentTypeReview success:^(NSString * _Nonnull photoUrl) {
            
            [photoUrls addObject:photoUrl];
            [photoCaptions addObject:photo.photoCaption];
            
            // all photos uploaded! submit content
            if ([photoUrls count] == [self.photos count]) {
                [self submitReviewWithPhotoUrls:BVSubmissionActionSubmit
                                      photoUrls:photoUrls
                                  photoCaptions:photoCaptions
                                        success:success
                                        failure:failure];
            }
            
        } failure:^(NSArray<NSError *> * _Nonnull errors) {
            
            if (!self.failureCalled) {
                self.failureCalled = true; // only call failure block once, if multiple photos failed.
                
                [[BVLogger sharedLogger] printErrors:errors];
                failure(errors);
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

-(void)submitReviewWithPhotoUrls:(BVSubmissionAction)BVSubmissionAction photoUrls:(nonnull NSArray<NSString*>*)photoUrls photoCaptions:(nonnull NSArray<NSString*>*)photoCaptions success:(nonnull ReviewSubmissionCompletion)success failure:(nonnull ConversationsFailureHandler)failure {
    
    
    NSDictionary* parameters = [self createSubmissionParameters:BVSubmissionAction photoUrls:photoUrls photoCaptions:photoCaptions];
    NSData* postBody = [self transformToPostBody:parameters];
    
    NSString* urlString = [NSString stringWithFormat:@"%@submitreview.json", [BVConversationsRequest commonEndpoint]];
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
            BVReviewSubmissionErrorResponse* errorResponse = [[BVReviewSubmissionErrorResponse alloc] initWithApiResponse:json]; // fails gracefully
            
            [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%d)", json, statusCode]];
            
            if (httpError) {
                // network error was generated
                [[BVLogger sharedLogger] printError:httpError];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(@[httpError]);
                });
            }
            else if(statusCode >= 300){
                // HTTP status code indicates failure
                NSError* statusError = [NSError errorWithDomain:@"com.bazaarvoice.bvsdk" code:BV_ERROR_NETWORK_FAILED userInfo:@{NSLocalizedDescriptionKey:@"Review upload failed."}];
                [[BVLogger sharedLogger] printError:statusError];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(@[statusError]);
                });
            }
            else if (jsonParsingError) {
                // json parsing failed
                [[BVLogger sharedLogger] printError:jsonParsingError];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(@[jsonParsingError]);
                });
            }
            else if(errorResponse){
                // api returned successfully, but has bazaarvoice-specific errors. Example: 'invalid api key'
                NSArray<NSError*>* errors = [errorResponse toNSErrors];
                [[BVLogger sharedLogger] printErrors:errors];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(errors);
                });
            }
            else {
                // success!
                BVReviewSubmissionResponse* response = [[BVReviewSubmissionResponse alloc] initWithApiResponse:json];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(response);
                });
            }
            
        }
        @catch (NSException *exception) {
            NSError* unexpectedError = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_UNKNOWN userInfo:@{NSLocalizedDescriptionKey:@"An unknown parsing error occurred."}];
            [[BVLogger sharedLogger] printError: unexpectedError];
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(@[unexpectedError]);
            });
        }
        
    }];
    
    // start uploading review
    [postDataTask resume];
    
}

-(nonnull NSDictionary*)createSubmissionParameters:(BVSubmissionAction)BVSubmissionAction photoUrls:(nonnull NSArray<NSString*>*)photoUrls photoCaptions:(nonnull NSArray<NSString*>*)photoCaptions {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                           @"apiversion": @"5.4",
                                           @"reviewtext": self.reviewText,
                                           @"title": self.reviewTitle,
                                           @"rating": [NSString stringWithFormat:@"%lu", self.rating],
                                           @"productId": self.productId
                                       }];
    
    parameters[@"passkey"] = [self getPasskey];
    parameters[@"action"] = [BVSubmissionActionUtil toString:BVSubmissionAction];
    
    parameters[@"campaignid"] = self.campaignId;
    parameters[@"locale"] = self.locale;
    
    if (self.sendEmailAlertWhenCommented) {
        parameters[@"sendemailalertwhencommented"] = [self.sendEmailAlertWhenCommented boolValue] ? @"true" : @"false";
    }
    
    if (self.sendEmailAlertWhenPublished) {
        parameters[@"sendemailalertwhenpublished"] = [self.sendEmailAlertWhenPublished boolValue] ? @"true" : @"false";
    }
    
    if (self.agreedToTermsAndConditions) {
        parameters[@"agreedtotermsandconditions"] = [self.agreedToTermsAndConditions boolValue] ? @"true" : @"false";
    }
    
    parameters[@"hostedauthentication_authenticationemail"] = self.hostedAuthenticationEmail;
    parameters[@"hostedauthentication_callbackurl"] = self.hostedAuthenticationCallback;
    parameters[@"netpromotercomment"] = self.netPromoterComment;
    
    if(self.netPromoterScore) {
        parameters[@"netpromoterscore"] = [NSString stringWithFormat:@"%i", [self.netPromoterScore intValue]];
    }
    
    parameters[@"fp"] = self.fingerPrint;
    
    if (self.isRecommended != nil){
        parameters[@"isrecommended"] = [self.isRecommended boolValue] == YES ? @"true" : @"false";
    }
    
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
    
    for (NSString* key in self.additionalFields) {
        parameters[key] = self.additionalFields[key];
    }
    for (NSString* key in self.contextDataValues) {
        parameters[key] = self.contextDataValues[key];
    }
    for (NSString* key in self.ratingQuestions) {
        parameters[key] = self.ratingQuestions[key];
    }
    for (NSString* key in self.ratingSliders) {
        parameters[key] = self.ratingSliders[key];
    }
    for (NSString* key in self.predefinedTags) {
        parameters[key] = self.predefinedTags[key];
    }
    for (NSString* key in self.freeformTags) {
        parameters[key] = self.freeformTags[key];
    }
    
    return parameters;
    
}

- (NSString * _Nonnull)getPasskey{
    return [BVSDKManager sharedManager].apiKeyConversations;
}

@end
