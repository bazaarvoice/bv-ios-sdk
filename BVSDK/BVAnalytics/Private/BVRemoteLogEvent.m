//
//  BVRemoteLogEvent.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVRemoteLogEvent.h"
#import "BVAnalyticEventManager+Private.h"
#import "BVCommon.h"
#import <UIKit/UIKit.h>

#define BV_ERROR_SCHEMA                                                        \
  @{                                                                           \
    @"cl" : @"Error",                                                          \
    @"type" : @"record",                                                       \
    @"ua_mobile" : @YES,                                                       \
    @"ua_platform" : @"ios-objc",                                              \
    @"hadPII" : @"false",                                                      \
    @"bvproductversion" : BV_SDK_VERSION,                                      \
    @"source" : @"native-mobile-sdk"                                           \
  }

@interface BVRemoteLogEvent ()
@property(nonnull, nonatomic, strong, readwrite) NSString *error;
@property(nonnull, nonatomic, strong, readwrite) NSString *localeIdentifier;
@property(nonnull, nonatomic, strong, readwrite) NSString *log;
@property(nonnull, nonatomic, strong, readwrite) NSString *bvProduct;
@end

@implementation BVRemoteLogEvent

@synthesize additionalParams;

- (nonnull instancetype)initWithError:(nonnull NSString *)error
                     localeIdentifier:(nonnull NSString *)localeIdentifier
                                  log:(nonnull NSString *)log
                            bvProduct:(nonnull NSString *)bvProduct {
  if ((self = [super init])) {
    self.error = error;
    self.localeIdentifier = localeIdentifier;
    self.log = log;
    self.bvProduct = bvProduct;
  }
  return self;
}

- (nonnull NSDictionary *)toRaw {
  NSMutableDictionary *eventDict = [NSMutableDictionary
      dictionaryWithDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDictAnonymous:YES]];
  [eventDict addEntriesFromDictionary:BV_ERROR_SCHEMA];

  NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
  if (systemVersion) {
    [eventDict setObject:systemVersion forKey:@"ua_platform_version"];
  }

  if (self.error) {
    [eventDict setObject:self.error forKey:@"detail2"];
  }

  if (self.localeIdentifier) {
    [eventDict setObject:self.localeIdentifier forKey:@"locale"];
  }

  if (self.log) {
    [eventDict setObject:self.log forKey:@"detail1"];
  }

  if (self.bvProduct) {
    [eventDict setObject:self.bvProduct forKey:@"bvproduct"];
  }

  return eventDict;
}

@end
