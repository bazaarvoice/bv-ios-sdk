//
//  BVQuestionsSortOption.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionsSortOptionValue.h"
#import "BVSortOption.h"

@interface BVQuestionsSortOption : BVSortOption

- (nonnull instancetype)initWithQuestionsSortOptionValue:
    (BVQuestionsSortOptionValue)questionsSortOptionValue;

@end
