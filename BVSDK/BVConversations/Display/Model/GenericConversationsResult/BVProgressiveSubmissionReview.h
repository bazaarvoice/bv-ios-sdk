//
//  BVProgressiveSubmissionReview.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReview.h"

NS_ASSUME_NONNULL_BEGIN

@interface BVProgressiveSubmissionReview : BVReview

@property(nullable) NSNumber *isFromSubmitDB;
@property(nullable) NSString *previousSubmissionID;
@property(nullable) NSDictionary *photoCollection;

@end

NS_ASSUME_NONNULL_END
