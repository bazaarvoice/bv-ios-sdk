//
//  BVCommentsRequest_Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVCommentsRequest.h"
#import "BVFilter.h"
#import "BVIncludeType.h"
#import "BVSort.h"

#ifndef BVCOMMENTSREQUEST_PRIVATE_H
#define BVCOMMENTSREQUEST_PRIVATE_H

@interface BVCommentsRequest ()

@property(nonnull, nonatomic, strong, readonly) NSMutableArray<BVSort *> *sorts;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *filters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVIncludeType *> *includes;

@end

#endif /* BVCOMMENTSREQUEST_PRIVATE_H */
