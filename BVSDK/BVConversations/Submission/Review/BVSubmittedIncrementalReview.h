//
//  BVSubmittedIncrementalReview.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSubmittedType.h"
#import "BVSubmittedReview.h"
#import "BVReview.h"

NS_ASSUME_NONNULL_BEGIN

@interface BVSubmittedIncrementalReview : BVSubmittedType
@property(nonnull) NSString *mprToken;
@property(nonnull) BVSubmittedReview *review;
@property(nonnull) NSString *submissionId;

@end

NS_ASSUME_NONNULL_END
