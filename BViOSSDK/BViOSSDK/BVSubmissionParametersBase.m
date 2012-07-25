//
//  BVSubmissionParametersBase.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@implementation NSDictionary (removeNullKeys)

- (NSDictionary*) removeNullValueKeys {
    NSDictionary* returnValue;
    NSMutableDictionary *nullFreeDict = [[NSMutableDictionary alloc] init];
    for (id key in self) {
        id value = [self objectForKey:key];
        if (![value isKindOfClass:[NSNull class]])
            [nullFreeDict setObject:value forKey:key];
    }
    
    returnValue = [NSDictionary dictionaryWithDictionary:nullFreeDict];
    
    return returnValue;
}

@end

@implementation BVSubmissionParametersBase

@synthesize action                          = _action;
@synthesize productId                       = _productId;
@synthesize additionalField                 = _additionalField;
@synthesize agreedToTermsAndConditions      = _agreedToTermsAndConditions;
@synthesize campaignId                      = _campaignId;
@synthesize contextDataValue                = _contextDataValue;
@synthesize isUserAnonymous                 = _isUserAnonymous;
@synthesize locale                          = _locale;
@synthesize photoCaption                    = _photoCaption;
@synthesize photoURL                        = _photoURL;
@synthesize productRecommendationId         = _productRecommendationId;
@synthesize sendEmailAlertWhenPublished     = _sendEmailAlertWhenPublished;
@synthesize tag                             = _tag;
@synthesize tagid                             = _tagid;
@synthesize userEmail                       = _userEmail;
@synthesize userId                          = _userId;
@synthesize userLocation                    = _userLocation;
@synthesize userNickName                    = _userNickName;
@synthesize videoCaption                    = _videoCaption;
@synthesize videoUrl                        = _videoUrl;

- (NSDictionary*) dictionaryOfValues {
    NSDictionary *returnDictionary = [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"action", @"productId"
                                    , @"agreedToTermsAndConditions", @"campaignId", @"isUserAnonymous", @"locale"
                                    , @"sendEmailAlertWhenPublished", @"userEmail", @"userId", @"userLocation"
                                    , @"userNickName", nil]];
    
  
    NSMutableDictionary *BVParamDict = [[NSMutableDictionary alloc] init];
    [BVParamDict addEntriesFromDictionary:[self.additionalField dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.contextDataValue dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.photoCaption dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.photoURL dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.productRecommendationId dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.tag dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.tagid dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.videoCaption dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.videoUrl dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:returnDictionary];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:BVParamDict]; // Return with the BVParams.
    returnDictionary = [returnDictionary removeNullValueKeys];
    return returnDictionary;
}

// Allocate memory for BVParametersType here.
- (BVParametersType*) additionalField {
    // Lazy instationation...
    if (_additionalField == nil) {
        _additionalField = [[BVParametersType alloc] init];
        _additionalField.prefixName = @"AdditionalField";
    }
    return _additionalField;
}

- (BVParametersType*) contextDataValue {
    // Lazy instationation...
    if (_contextDataValue == nil) {
        _contextDataValue = [[BVParametersType alloc] init];
        _contextDataValue.prefixName = @"ContextDataValue";
    }
    return _contextDataValue;
}

- (BVParametersType*) photoCaption {
    // Lazy instationation...
    if (_photoCaption == nil) {
        _photoCaption = [[BVParametersType alloc] init];
        _photoCaption.prefixName = @"PhotoCaption";
    }
    return _photoCaption;
}

- (BVParametersType*) photoURL {
    // Lazy instationation...
    if (_photoURL == nil) {
        _photoURL = [[BVParametersType alloc] init];
        _photoURL.prefixName = @"PhotoUrl";
    }
    return _photoURL;
}

- (BVParametersType*) productRecommendationId {
    // Lazy instationation...
    if (_productRecommendationId == nil) {
        _productRecommendationId = [[BVParametersType alloc] init];
        _productRecommendationId.prefixName = @"ProductRecommendationId";
    }
    return _productRecommendationId;
}

- (BVParametersType*) tag {
    // Lazy instationation...
    if (_tag == nil) {
        _tag = [[BVParametersType alloc] init];
        _tag.prefixName = @"tag";
    }
    return _tag;
}

- (BVParametersType*) tagid {
    // Lazy instationation...
    if (_tagid == nil) {
        _tagid = [[BVParametersType alloc] init];
        _tagid.prefixName = @"tagid";
    }
    return _tagid;
}

- (BVParametersType*) videoCaption {
    // Lazy instationation...
    if (_videoCaption == nil) {
        _videoCaption = [[BVParametersType alloc] init];
        _videoCaption.prefixName = @"VideoCaption";
    }
    return _videoCaption;
}

- (BVParametersType*) videoUrl {
    // Lazy instationation...
    if (_videoUrl == nil) {
        _videoUrl = [[BVParametersType alloc] init];
        _videoUrl.prefixName = @"VideoUrl";
    }
    return _videoUrl;
}

@end