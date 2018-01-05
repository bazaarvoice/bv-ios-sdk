//
//  BVReviewFilterType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilterType.h"
#import "BVReviewFilterValue.h"

@interface BVReviewFilterType : BVFilterType

- (nonnull instancetype)initWithReviewFilterValue:
    (BVReviewFilterValue)reviewFilterValue;

@end
