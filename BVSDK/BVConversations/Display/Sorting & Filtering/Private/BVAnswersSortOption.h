//
//  BVAnswersSortOption.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswersSortOptionValue.h"
#import "BVSortOption.h"

@interface BVAnswersSortOption : BVSortOption

- (nonnull instancetype)initWithAnswersSortOptionValue:
    (BVAnswersSortOptionValue)answersSortOptionValue;

@end
