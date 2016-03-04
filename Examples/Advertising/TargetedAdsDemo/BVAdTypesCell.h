//
//  NativeAdTypesCell.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BVAdTypesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView* backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel* cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel* cellDescriptionLabel;

@end
