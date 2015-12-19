//
//  TestStaticView.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestBase.h"
#import <BVSDK/BVStaticViewCell.h>

@interface TestStaticView : TestBase

@property CGRect small, medium, large;

@end

@implementation TestStaticView

- (void)setUp {
    [super setUp];
    
    self.small = CGRectMake(0, 0, 300, 180);
    self.medium = CGRectMake(0, 0, 375, 220);
    self.large = CGRectMake(0, 0, 450, 250);
    
    // Flip this to YES to record images in the reference image directory.
    // You need to do this the first time you create a test and whenever you change the snapshotted views.
    // Tests running in record mode will allways fail so that you know that you have to do something here before you commit.
    self.recordMode = false;
}

-(BVStaticViewCell*)getTableCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"BVStaticViewCell" owner:self options:nil] firstObject];
}

- (void)tableCell:(CGRect)frame {
    
    BVStaticViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenPrice:(CGRect)frame {
    
    BVStaticViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setPriceHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenStars:(CGRect)frame {
    
    BVStaticViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setStarsAndReviewStatsHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenReviewAndAuthor:(CGRect)frame {
    
    BVStaticViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setReviewAndAuthorHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenButtons:(CGRect)frame {
    
    BVStaticViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setLikeButtonHidden:true];
    [cell.recommendationsView setDislikeButtonHidden:true];
    [cell.recommendationsView setShopButtonHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

#pragma mark - no hidden fields

- (void)test_small {
    [self tableCell:self.small];
}

- (void)test_medium {
    [self tableCell:self.medium];
}

- (void)test_large {
    [self tableCell:self.large];
}

#pragma mark - price hidden

- (void)testHiddenPrice_small {
    [self tableCellHiddenPrice:self.small];
}

- (void)testHiddenPrice_medium {
    [self tableCellHiddenPrice:self.medium];
}

- (void)testHiddenPrice_large {
    [self tableCellHiddenPrice:self.large];
}


#pragma mark - stars hidden

- (void)testHiddenStars_small {
    [self tableCellHiddenStars:self.small];
}

- (void)testHiddenStars_medium {
    [self tableCellHiddenStars:self.medium];
}

- (void)testHiddenStars_large {
    [self tableCellHiddenStars:self.large];
}

#pragma mark - review and author hidden

- (void)testHiddenReviewAndAuthor_small {
    [self tableCellHiddenReviewAndAuthor:self.small];
}

- (void)testHiddenReviewAndAuthor_medium {
    [self tableCellHiddenReviewAndAuthor:self.medium];
}

- (void)testHiddenReviewAndAuthor_large {
    [self tableCellHiddenReviewAndAuthor:self.large];
}


#pragma mark - buttons hidden

- (void)testHiddenButtons_small {
    [self tableCellHiddenButtons:self.small];
}

- (void)testHiddenButtons_medium {
    [self tableCellHiddenButtons:self.medium];
}

- (void)testHiddenButtons_large {
    [self tableCellHiddenButtons:self.large];
}


@end