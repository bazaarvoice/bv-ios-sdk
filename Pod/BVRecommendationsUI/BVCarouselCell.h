//
//  BVCarouselCell.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVRecommendationsSharedView.h"

@interface BVCarouselCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BVRecommendationsSharedView* recommendationsView;

@end
