//
//  BVRecommendationCellDelegate.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVRecommendationCellDelegate_h
#define BVRecommendationCellDelegate_h

#import "BVProduct.h"

@protocol BVRecommendationCellDelegate <NSObject>

@optional

- (void)_didToggleLike:(BVProduct *)product withNewValue:(BOOL)flag;

- (void)_didToggleDislike:(BVProduct *)product withNewValue:(BOOL)flag shouldRemove:(BOOL)remove;

- (void)_didSelectShopNow:(BVProduct *)product;

@end


#endif /* BVRecommendationCellDelegate_h */
