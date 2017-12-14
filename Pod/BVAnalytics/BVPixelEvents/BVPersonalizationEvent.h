//
//  BVPersonalizationEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAnalyticEvent.h"
#import <Foundation/Foundation.h>

#define PERSONALIZATION_SCHEMA                                                 \
  @{                                                                           \
    @"cl" : @"Personalization",                                                \
    @"type" : @"ProfileMobile",                                                \
    @"bvProduct" : @"ShopperMarketing"                                         \
  }

/**
 Set user information. Associates a user profile with device for taylored
 recommendations.
 Use of this method requires that a valid key has been set for
 apiKeyShopperMarketing.
*/
@interface BVPersonalizationEvent : NSObject <BVAnalyticEvent>

- (nonnull id)initWithUserAuthenticationString:(nonnull NSString *)uas;

- (nonnull instancetype)__unavailable init;

/// Generated user authentication string endoded with shared secret. Generated
/// by your server-side implementation.
@property(nonnull, nonatomic, strong, readonly) NSString *uas;

@end
