//
//  DemoCell.m
//  RecommendationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "DemoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DemoCell ()

@property IBOutlet UILabel *productName;
@property IBOutlet UILabel *price;
@property IBOutlet UILabel *numReview;
@property IBOutlet UILabel *rating;
@property IBOutlet UIImageView *productImageView;
@property IBOutlet HCSStarRatingView *starRating;

@end

@implementation DemoCell

- (void)setBvProduct:(BVProduct *)bvProduct {
    
    super.bvProduct = bvProduct;
    
    NSURL *url = [NSURL URLWithString:self.bvProduct.imageURL];
    [self.productImageView sd_setImageWithURL:url];
    self.productName.text = bvProduct.productName;
    self.rating.text = [NSString stringWithFormat:@"%.1f", [bvProduct.averageRating floatValue]];
    self.starRating.value = [bvProduct.averageRating floatValue];
    self.numReview.text = [NSString stringWithFormat:@"(%ld)", [bvProduct.numReviews longValue]];
    self.price.text = bvProduct.price;
   
}

@end