//
//  BVReviewIncludeType.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>


/// Types of Bazaarvoice content that can be included with a Profile.
typedef NS_ENUM(NSInteger, BVReviewIncludeType) {
    BVReviewIncludeTypeProducts
};


@interface BVReviewIncludeTypeUtil : NSObject

+(NSString*)toString:(BVReviewIncludeType)type;

@end
