//
//  BVSDKConfiguration.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVSDKConfiguration.h"
@implementation BVSDKConfiguration

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dict
                                configType:(BVConfigurationType)type {
  if ((self = [super init])) {
    _staging = type == BVConfigurationTypeStaging;
    for (NSString *key in dict) {
      if ([self respondsToSelector:NSSelectorFromString(key)]) {
        [self setValue:dict[key] forKeyPath:key];
      } else {
        [[BVLogger sharedLogger]
            error:[NSString stringWithFormat:@"Unrecognized "
                                             @"configuration option "
                                             @"\"%@\" will be ignored",
                                             key]];
      }
    }
  }
  return self;
}

@end
