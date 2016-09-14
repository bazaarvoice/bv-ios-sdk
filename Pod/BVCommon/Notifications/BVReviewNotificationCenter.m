//
//  BVNotificationCenter.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVReviewNotificationCenter.h"
#import "BVReviewRichNotificationCenter.h"
#import "BVReviewSimpleNotificationCenter.h"

@implementation BVReviewNotificationCenter

+(instancetype _Nonnull)sharedCenter;
{
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            _sharedObject = [[BVReviewRichNotificationCenter alloc] init];
        }else {
            _sharedObject = [[BVReviewSimpleNotificationCenter alloc] init];
        }
    });
    
    return _sharedObject;
}

@end
