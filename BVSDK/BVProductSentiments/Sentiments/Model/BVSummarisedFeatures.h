//
//  BVSummarisedFeatures.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductFeature.h"

/*
 Best and Worst features of a product.
 */
@interface BVSummarisedFeatures : NSObject
                                        
@property(nullable) NSArray<BVProductFeature *> *bestFeatures;
@property(nullable) NSArray<BVProductFeature *> *worstFeatures;
@property(nullable) NSNumber *status;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSString *type;
@property(nullable) NSString *instance;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
