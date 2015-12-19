//
//  BVStaticViewCell.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVRecommendationsSharedView.h"

@interface BVStaticViewCell : UIView

@property (weak, nonatomic) IBOutlet BVRecommendationsSharedView* recommendationsView;

@end
