//
//  BVSummarisedFeatures.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductFeature.h"
#import "BVProductSentimentsResult.h"

/*
 Best and Worst features of a product.
 */

@class BVProductFeature;

@interface BVSummarisedFeatures : BVProductSentimentsResult
                                        
@property(nullable) NSArray<BVProductFeature *> *bestFeatures;
@property(nullable) NSArray<BVProductFeature *> *worstFeatures;
@property(nullable) NSNumber *status;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSString *type;
@property(nullable) NSString *instance;

@property(nullable) BVProductFeature *firstFeatures;
@property(nullable) NSNumber *pp;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
