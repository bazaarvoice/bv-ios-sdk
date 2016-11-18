//
//  BVProductReviewNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVProductReviewNotificationCenter.h"

#import "BVProductReviewRichNotificationCenter.h"
#import "BVProductReviewSimpleNotificationCenter.h"

@implementation BVProductReviewNotificationCenter

+(instancetype _Nonnull)sharedCenter;
{
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            _sharedObject = [[BVProductReviewRichNotificationCenter alloc] init];
        }else {
            _sharedObject = [[BVProductReviewSimpleNotificationCenter alloc] init];
        }
    });
    
    return _sharedObject;
}

@end
