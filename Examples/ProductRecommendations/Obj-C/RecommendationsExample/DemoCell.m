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

- (void)setBvRecommendedProduct:(BVRecommendedProduct *)bvRecommendedProduct {

  super.bvRecommendedProduct = bvRecommendedProduct;

  NSURL *url = [NSURL URLWithString:self.bvRecommendedProduct.imageURL];
  [self.productImageView sd_setImageWithURL:url];
  self.productName.text = bvRecommendedProduct.productName;
  self.rating.text = [NSString
      stringWithFormat:@"%.1f",
                       [bvRecommendedProduct.averageRating floatValue]];
  self.starRating.value = [bvRecommendedProduct.averageRating floatValue];
  self.numReview.text = [NSString
      stringWithFormat:@"(%ld)", [bvRecommendedProduct.numReviews longValue]];
  self.price.text = bvRecommendedProduct.price;
}

@end