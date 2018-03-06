//
//  BVReviewsSortOption.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewsSortOptionValue.h"
#import "BVSortOption.h"

@interface BVReviewsSortOption : BVSortOption

- (nonnull instancetype)initWithReviewsSortOptionValue:
    (BVReviewsSortOptionValue)reviewsSortOptionValue;

@end
