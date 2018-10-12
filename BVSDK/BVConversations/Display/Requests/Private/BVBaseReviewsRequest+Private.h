//
//  BVBaseReviewsRequest+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVBASEREVIEWSREQUEST_PRIVATE_H
#define BVBASEREVIEWSREQUEST_PRIVATE_H

#import "BVBaseReviewsRequest.h"
#import "BVFilter.h"
#import "BVIncludeType.h"
#import "BVSort.h"

@interface BVBaseReviewsRequest ()

@property(nonnull, nonatomic, strong, readonly) NSMutableArray<BVSort *> *sorts;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *filters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVIncludeType *> *includes;

@end

#endif /* BVBASEREVIEWSREQUEST_PRIVATE_H */
