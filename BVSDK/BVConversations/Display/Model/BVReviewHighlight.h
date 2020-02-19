//
//  BVReviewHighlight.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewHighligtsReview.h"

@interface BVReviewHighlight : NSObject

@property(nullable) NSNumber *presenceCount;
@property(nullable) NSNumber *mentionsCount;
@property(nullable) NSArray<BVReviewHighligtsReview *> *bestExamples;

//TODO
@property(nullable) NSString *title;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;
- (nullable id)initWithTitle:(NSString *_Nullable)title content:(nullable id) content;

@end
