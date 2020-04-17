//
//  BVReviewHighlight.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewHighlightsReview.h"

@interface BVReviewHighlight : NSObject

@property(nullable) NSNumber *presenceCount;
@property(nullable) NSNumber *mentionsCount;
@property(nullable) NSArray<BVReviewHighlightsReview *> *bestExamples;
@property(nullable) NSString *title;

- (nullable id)initWithTitle:(NSString *_Nullable)title content:(nullable id) content;


@end
