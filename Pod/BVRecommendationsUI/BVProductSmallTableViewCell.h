//
//  BVProductSmallTableViewCell.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVCore.h"

#import "BVRecommendationsSharedView.h"

@interface BVProductSmallTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BVRecommendationsSharedView* recommendationsView;

@end

