//
//  BVQuestionFilterType.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilterType.h"
#import "BVQuestionFilterValue.h"

@interface BVQuestionFilterType : BVFilterType

- (nonnull instancetype)initWithQuestionFilterValue:
    (BVQuestionFilterValue)questionFilterValue;

@end
