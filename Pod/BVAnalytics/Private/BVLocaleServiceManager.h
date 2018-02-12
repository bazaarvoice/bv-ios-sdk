//
//  BVLocaleServiceManager.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The types of services that require Locale specific actions.
typedef NS_ENUM(NSUInteger, BVLocaleServiceManagerService) {
  BVLocaleServiceManagerServiceAnalytics
};

@interface BVLocaleServiceManager : NSObject

/// Create and get the singleton instance of the region manager.
+ (nonnull BVLocaleServiceManager *)sharedManager;

/// Acquire the base URL for service given a region object
- (nonnull NSString *)resourceForService:(BVLocaleServiceManagerService)service
                              withLocale:(nonnull NSLocale *)locale
                         andIsProduction:(BOOL)isProduction;

@end
