//
//  BVSDKConfiguration.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVSDKConfiguration.h"
#import "BVLogger+Private.h"
#import "BVSDKManager+Private.h"

@implementation BVSDKConfiguration

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dict
                                configType:(BVConfigurationType)type {
  if ((self = [super init])) {
    _staging = type == BVConfigurationTypeStaging;
    for (NSString *key in dict) {
      if ([self respondsToSelector:NSSelectorFromString(key)]) {
        [self setValue:dict[key] forKeyPath:key];
      } else {
        BVLogError(
            ([NSString
                stringWithFormat:
                    @"Unrecognized configuration option \"%@\" will be ignored",
                    key]),
            BV_PRODUCT_COMMON);
      }
    }
  }
  return self;
}

@end
