//
//  BVNotificationConfiguration.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVProductReviewNotificationProperties.h"
#import "BVStoreReviewNotificationProperties.h"
#import <Foundation/Foundation.h>

#define S3_API_VERSION @"v1"
#define NOTIFICATION_CONFIG_ROOT @"https://s3.amazonaws.com"

@interface BVNotificationConfiguration : NSObject

+ (void)
loadGeofenceConfiguration:(nonnull NSURL *)url
               completion:(nonnull void (^)(BVStoreReviewNotificationProperties
                                                *__nonnull response))completion
                  failure:(nonnull void (^)(NSError *__nonnull errors))failure;
+ (void)
loadPINConfiguration:(nonnull NSURL *)url
          completion:(nonnull void (^)(BVProductReviewNotificationProperties
                                           *__nonnull response))completion
             failure:(nonnull void (^)(NSError *__nonnull errors))failure;

@end
