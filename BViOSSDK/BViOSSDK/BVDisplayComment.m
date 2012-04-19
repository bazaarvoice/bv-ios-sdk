//
//  BVComment.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/25/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVDisplayComment.h"

@implementation BVDisplayReviewComment

- (NSString*) displayType {
    return @"reviewcomments";
}

@end

@implementation BVDisplayStoryComment

- (NSString*) displayType {
    return @"storycomments";
}

@end