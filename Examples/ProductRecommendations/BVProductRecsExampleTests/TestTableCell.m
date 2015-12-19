//
//  TestTableCell.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestBase.h"
#import <BVSDK/BVProductLargeTableViewCell.h>

@interface TestTableCell : TestBase

@end

@implementation TestTableCell

- (void)setUp {
    [super setUp];
    
    // Flip this to YES to record images in the reference image directory.
    // You need to do this the first time you create a test and whenever you change the snapshotted views.
    // Tests running in record mode will allways fail so that you know that you have to do something here before you commit.
    self.recordMode = false;
}

-(BVProductLargeTableViewCell*)getTableCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"BVProductLargeTableViewCell" owner:self options:nil] firstObject];
}

- (void)tableCell:(CGRect)frame {
    
    BVProductLargeTableViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenPrice:(CGRect)frame {
    
    BVProductLargeTableViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setPriceHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenStars:(CGRect)frame {
    
    BVProductLargeTableViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setStarsAndReviewStatsHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenReviewAndAuthor:(CGRect)frame {
    
    BVProductLargeTableViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setReviewAndAuthorHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

- (void)tableCellHiddenButtons:(CGRect)frame {
    
    BVProductLargeTableViewCell* cell = [self getTableCell];
    [cell.recommendationsView setProduct:self.testProduct];
    [cell.recommendationsView setLikeButtonHidden:true];
    [cell.recommendationsView setDislikeButtonHidden:true];
    [cell.recommendationsView setShopButtonHidden:true];
    [cell setFrame:frame];
    
    [self waitAndCheck:cell];
}

#pragma mark - no hidden fields

- (void)test_iphone_5 {
    [self tableCell:self.iphone_5];
}

- (void)test_iphone_6 {
    [self tableCell:self.iphone_6];
}

- (void)test_iphone_6plus {
    [self tableCell:self.iphone_6plus];
}

- (void)test_ipad {
    [self tableCell:self.ipad];
}

#pragma mark - price hidden

- (void)testHiddenPrice_iphone_5 {
    [self tableCellHiddenPrice:self.iphone_5];
}

- (void)testHiddenPrice_iphone_6 {
    [self tableCellHiddenPrice:self.iphone_6];
}

- (void)testHiddenPrice_iphone_6plus {
    [self tableCellHiddenPrice:self.iphone_6plus];
}

- (void)testHiddenPrice_ipad {
    [self tableCellHiddenPrice:self.ipad];
}

#pragma mark - stars hidden

- (void)testHiddenStars_iphone_5 {
    [self tableCellHiddenStars:self.iphone_5];
}

- (void)testHiddenStars_iphone_6 {
    [self tableCellHiddenStars:self.iphone_6];
}

- (void)testHiddenStars_iphone_6plus {
    [self tableCellHiddenStars:self.iphone_6plus];
}

- (void)testHiddenStars_ipad {
    [self tableCellHiddenStars:self.ipad];
}

#pragma mark - review and author hidden

- (void)testHiddenReviewAndAuthor_iphone_5 {
    [self tableCellHiddenReviewAndAuthor:self.iphone_5];
}

- (void)testHiddenReviewAndAuthor_iphone_6 {
    [self tableCellHiddenReviewAndAuthor:self.iphone_6];
}

- (void)testHiddenReviewAndAuthor_iphone_6plus {
    [self tableCellHiddenReviewAndAuthor:self.iphone_6plus];
}

- (void)testHiddenReviewAndAuthor_ipad {
    [self tableCellHiddenReviewAndAuthor:self.ipad];
}

#pragma mark - buttons hidden

- (void)testHiddenButtons_iphone_5 {
    [self tableCellHiddenButtons:self.iphone_5];
}

- (void)testHiddenButtons_iphone_6 {
    [self tableCellHiddenButtons:self.iphone_6];
}

- (void)testHiddenButtons_iphone_6plus {
    [self tableCellHiddenButtons:self.iphone_6plus];
}

- (void)testHiddenButtons_ipad {
    [self tableCellHiddenButtons:self.ipad];
}

@end