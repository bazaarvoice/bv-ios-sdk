//
//  BVProductFeatures.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductFeatures_h
#define BVProductFeatures_h

#import <Foundation/Foundation.h>
#import "BVProductFeature.h"

/*
 Best and Worst features of a product.
 */
@interface BVProductFeatures : NSObject
                                        
@property(nullable) NSArray<BVProductFeature *> *features;
@property(nullable) NSNumber *status;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSString *type;
@property(nullable) NSString *instance;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

#endif /* BVProductFeatures_h */
