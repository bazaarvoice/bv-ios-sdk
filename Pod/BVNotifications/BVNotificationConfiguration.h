//
//  BVNotificationConfiguration.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVStoreReviewNotificationProperties.h"
#import "BVProductReviewNotificationProperties.h"

#define S3_API_VERSION @"v1"
#define NOTIFICATION_CONFIG_ROOT @"https://s3.amazonaws.com"

@interface BVNotificationConfiguration : NSObject

+ (void)loadGeofenceConfiguration:(NSURL * _Nonnull)url completion:(void (^ _Nonnull)(BVStoreReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull errors))failure;
+ (void)loadPINConfiguration:(NSURL * _Nonnull)url completion:(void (^ _Nonnull)(BVProductReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull errors))failure;

@end
