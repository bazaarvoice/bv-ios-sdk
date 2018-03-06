//
//  BVCommentIncludeType.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentIncludeTypeValue.h"
#import "BVIncludeType.h"

@interface BVCommentIncludeType : BVIncludeType

- (nonnull instancetype)initWithCommentIncludeTypeValue:
    (BVCommentIncludeTypeValue)commentIncludeTypeValue;

@end
