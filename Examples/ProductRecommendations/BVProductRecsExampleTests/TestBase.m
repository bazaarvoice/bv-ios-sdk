//
//  TestJason.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "TestBase.h"
#import <Foundation/Foundation.h>

@interface TestBase()

@end

@implementation TestBase

- (void)setUp {
    [super setUp];
    
    self.iphone_5 = CGRectMake(0, 0, 320, 320);
    self.iphone_6 = CGRectMake(0, 0, 375, 375);
    self.iphone_6plus = CGRectMake(0, 0, 414, 414);
    self.ipad = CGRectMake(0, 0, 768, 768);
    
    [self createExpectation];
    [self createTestProduct];
}

-(void)createExpectation {
    self.expectation = [self expectationWithDescription:@"TestExpectation"];
}

-(void)createTestProduct {
    self.testProduct = [[BVProduct alloc] init];
    
    self.testProduct.productId = @"";
    
    self.testProduct.productId = @"12345";
    self.testProduct.imageURL = @"http://s7d9.scene7.com/is/image/JCPenney/DP1102201520431499C?hei=350&wid=350";
    self.testProduct.productName = @"St. John's Bay® Long-Sleeve Legacy Plaid Flannel Shirt";
    self.testProduct.productPageURL = @"http://www.jcpenney.com/st-johns-bay-long-sleeve-plaid-flannel-shirt/prod.jump?ppId=pp5005151849";
    self.testProduct.price = @"$36.95";
    self.testProduct.review = [[BVProductReview alloc] init];
    self.testProduct.review.reviewText = @"Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum";
    self.testProduct.review.reviewTitle = @"Great durability";
    self.testProduct.review.reviewAuthorName = @"John Doe";
    self.testProduct.averageRating = @(4.5);
    self.testProduct.numReviews = @(124);
}

-(void)waitAndCheck:(UIView*)view {
    [self performSelector:@selector(checkViews:) withObject:view afterDelay:0.4];
    
    [self waitForExpectationsWithTimeout:0.5 handler:^(NSError * _Nullable error) {
        NSLog(@"Failed testLargeTableViewCell");
    }];
}

-(void)checkViews:(UIView*)view {
    
    FBSnapshotVerifyView(view, nil);
    FBSnapshotVerifyLayer(view.layer, nil);
    
    [self.expectation fulfill];
}

@end