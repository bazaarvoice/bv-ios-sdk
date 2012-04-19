//
//  BVSubmissionParametersBase.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVParameters.h"

@interface NSDictionary (removeNullKeys)
- (NSDictionary*) removeNullValueKeys;
@end

@interface BVSubmissionParametersBase : BVParameters

@property (nonatomic, copy) NSString* action;
@property (nonatomic, copy) NSString* productId;
@property (nonatomic, strong) BVParametersType* additionalField;
@property (nonatomic, copy) NSString* agreedToTermsAndConditions;
@property (nonatomic, copy) NSString* campaignId;
@property (nonatomic, strong) BVParametersType* contextDataValue;
@property (nonatomic, copy) NSString* isUserAnonymous;
@property (nonatomic, copy) NSString* locale;
@property (nonatomic, strong) BVParametersType* photoCaption;
@property (nonatomic, strong) BVParametersType* photoURL;
@property (nonatomic, strong) BVParametersType* productRecommendationId;
@property (nonatomic, copy) NSString* sendEmailAlertWhenPublished;
@property (nonatomic, strong) BVParametersType* tag;
@property (nonatomic, copy) NSString* userEmail;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* userLocation;
@property (nonatomic, copy) NSString* userNickName;
@property (nonatomic, strong) BVParametersType* videoCaption;
@property (nonatomic, strong) BVParametersType* videoUrl;

// Get a dictionary of values that were set.
@property (nonatomic, readonly) NSDictionary* dictionaryOfValues;

@end