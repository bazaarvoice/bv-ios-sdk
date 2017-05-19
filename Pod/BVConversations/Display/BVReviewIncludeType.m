//
//  BVReviewIncludeType.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVReviewIncludeType.h"

@implementation BVReviewIncludeTypeUtil

+(NSString*)toString:(BVReviewIncludeType)type {
    switch (type) {
        case BVReviewIncludeTypeProducts: return @"Products";
        case BVReviewIncludeTypeComments: return @"Comments";
    }
}

@end
