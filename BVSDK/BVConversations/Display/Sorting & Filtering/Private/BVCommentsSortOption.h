//
//  BVCommentsSortOption.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentsSortOptionValue.h"
#import "BVSortOption.h"

@interface BVCommentsSortOption : BVSortOption

- (nonnull instancetype)initWithSortOptionCommentsValue:
    (BVCommentsSortOptionValue)commentsSortOptionValue;

@end
