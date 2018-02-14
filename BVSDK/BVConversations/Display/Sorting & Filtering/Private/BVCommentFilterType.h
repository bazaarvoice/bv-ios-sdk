//
//  BVCommentFilterValue.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentFilterValue.h"
#import "BVFilterType.h"

@interface BVCommentFilterType : BVFilterType

- (nonnull instancetype)initWithCommentFilterValue:
    (BVCommentFilterValue)commentFilterValue;

@end
