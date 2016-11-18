//
//  BVNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVStoreReviewNotificationCenter.h"
#import "BVStoreReviewRichNotificationCenter.h"
#import "BVStoreReviewSimpleNotificationCenter.h"

@implementation BVStoreReviewNotificationCenter

+(instancetype _Nonnull)sharedCenter;
{
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            _sharedObject = [[BVStoreReviewRichNotificationCenter alloc] init];
        }else {
            _sharedObject = [[BVStoreReviewSimpleNotificationCenter alloc] init];
        }
    });
    
    return _sharedObject;
}

@end
