//
//  BVProductPageViews.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductPageViews.h"
#import "BVBrand.h"
#import "BVPixel.h"

@interface BVProductDisplayPageViewController () {
  BOOL hasSentPageviewEvent;
}
@end

@implementation BVProductDisplayPageViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!hasSentPageviewEvent && self.product) {
    hasSentPageviewEvent = YES;

    NSString *brandName = self.product.brand ? self.product.brand.name : nil;
    BVPageViewEvent *pageView = [[BVPageViewEvent alloc]
             initWithProductId:self.product.identifier
        withBVPixelProductType:BVPixelProductTypeConversationsReviews
                     withBrand:brandName
                withCategoryId:self.product.categoryId
            withRootCategoryId:nil
          withAdditionalParams:nil];

    [BVPixel trackEvent:pageView];
  }
}

@end

@interface BVProductDisplayPageTableViewController () {
  BOOL hasSentPageviewEvent;
}
@end

@implementation BVProductDisplayPageTableViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!hasSentPageviewEvent && self.product) {
    hasSentPageviewEvent = YES;

    NSString *brandName = self.product.brand ? self.product.brand.name : nil;
    BVPageViewEvent *pageView = [[BVPageViewEvent alloc]
             initWithProductId:self.product.identifier
        withBVPixelProductType:BVPixelProductTypeConversationsReviews
                     withBrand:brandName
                withCategoryId:self.product.categoryId
            withRootCategoryId:nil
          withAdditionalParams:nil];

    [BVPixel trackEvent:pageView];
  }
}

@end

@interface BVProductDisplayPageCollectionViewController () {
  BOOL hasSentPageviewEvent;
}
@end

@implementation BVProductDisplayPageCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!hasSentPageviewEvent && self.product) {
    hasSentPageviewEvent = YES;

    NSString *brandName = self.product.brand ? self.product.brand.name : nil;
    BVPageViewEvent *pageView = [[BVPageViewEvent alloc]
             initWithProductId:self.product.identifier
        withBVPixelProductType:BVPixelProductTypeConversationsReviews
                     withBrand:brandName
                withCategoryId:self.product.categoryId
            withRootCategoryId:nil
          withAdditionalParams:nil];

    [BVPixel trackEvent:pageView];
  }
}

@end
