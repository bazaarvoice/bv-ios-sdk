//
//  TestCarouselCell.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestBase.h"
#import <BVSDK/BVCarouselCell.h>

@interface TestCarouselCell : TestBase

@property CGRect small, medium, large;

@end

@implementation TestCarouselCell

- (void)setUp {
    [super setUp];
    
    self.small  = CGRectMake(0, 0, 160, 160);
    self.medium = CGRectMake(0, 0, 300, 300);
    self.large  = CGRectMake(0, 0, 450, 400);
    
    // Flip this to YES to record images in the reference image directory.
    // You need to do this the first time you create a test and whenever you change the snapshotted views.
    // Tests running in record mode will allways fail so that you know that you have to do something here before you commit.
    self.recordMode = false;
}


- (void)carouselCellWithSize:(CGRect)frame {
    
    BVCarouselCell* cell = (BVCarouselCell*)[[[NSBundle mainBundle] loadNibNamed:@"BVCarouselCell" owner:self options:nil] firstObject];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)carouselCellHiddenPrice:(CGRect)frame {
    
    BVCarouselCell* cell = (BVCarouselCell*)[[[NSBundle mainBundle] loadNibNamed:@"BVCarouselCell" owner:self options:nil] firstObject];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setPriceHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)carouselCellHiddenStars:(CGRect)frame {
    
    BVCarouselCell* cell = (BVCarouselCell*)[[[NSBundle mainBundle] loadNibNamed:@"BVCarouselCell" owner:self options:nil] firstObject];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setStarsAndReviewStatsHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)carouselCellHiddenStarsAndPrice:(CGRect)frame {
    
    BVCarouselCell* cell = (BVCarouselCell*)[[[NSBundle mainBundle] loadNibNamed:@"BVCarouselCell" owner:self options:nil] firstObject];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setStarsAndReviewStatsHidden:true];
    [cell.recommendationsView setPriceHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

#pragma mark - no hidden fields

- (void)testSmall {
    [self carouselCellWithSize:self.small];
}

- (void)testMedium {
    [self carouselCellWithSize:self.medium];
}

- (void)testLarge {
    [self carouselCellWithSize:self.large];
}

#pragma mark - hidden price

- (void)testHiddenPriceSmall {
    [self carouselCellHiddenPrice:self.small];
}

- (void)testHiddenPriceMedium {
    [self carouselCellHiddenPrice:self.medium];
}

- (void)testHiddenPriceLarge {
    [self carouselCellHiddenPrice:self.large];
}

#pragma mark - hidden stars

- (void)testHiddenStarsSmall {
    [self carouselCellHiddenStars:self.small];
}

- (void)testHiddenStarsMedium {
    [self carouselCellHiddenStars:self.medium];
}

- (void)testHiddenStarsLarge {
    [self carouselCellHiddenStars:self.large];
}

#pragma mark - hidden stars and price

- (void)testHiddenStarsAndPriceSmall {
    [self carouselCellHiddenStarsAndPrice:self.small];
}

- (void)testHiddenStarsAndPriceMedium {
    [self carouselCellHiddenStarsAndPrice:self.medium];
}

- (void)testHiddenStarsAndPriceLarge {
    [self carouselCellHiddenStarsAndPrice:self.large];
}

@end