//
//  BVNotificationConfiguration.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVStoreReviewNotificationProperties.h"

@interface BVNotificationConfiguration : NSObject

+ (void)loadConfiguration:(NSURL * _Nonnull)url completion:(void (^ _Nonnull)(BVStoreReviewNotificationProperties* _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull errors))failure;

@end
