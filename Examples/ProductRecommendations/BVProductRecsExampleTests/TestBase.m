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
    
    self.testProduct.product_key = @"apitestcustomer/12345";
    self.testProduct.client = @"apitestcustomer";
    self.testProduct.product_id = @"12345";
    self.testProduct.product_description = @"Make sure your cold-weather style is properly buttoned up in this plaid flannel shirt from St. John's Bay, available in your choice of lasting, yarn-dyed colors. \n \n\t\n\n\t\tyarn dyed for consistent, lasting color\n\n\t\n\n\t\tclassic fit\n\n\t\n\n\t\tbutton-down collar\n\n\t\n\n\t\tbutton front\n\n\t\n\n\t\tleft chest pocket\n\n\t\n\n\t\tlong sleeves\n\n\t\n\n\t\tadjustable button cuffs\n\n\t\n\n\t\trounded hem\n\n\t\n\n\t\tcotton\n\n\t\n\n\t\twashable\n\n\t\n\n\t\timported";
    self.testProduct.image_url = @"http://s7d9.scene7.com/is/image/JCPenney/DP1102201520431499C?hei=350&wid=350";
    self.testProduct.name = @"St. John's Bay® Long-Sleeve Legacy Plaid Flannel Shirt";
    self.testProduct.client_id = @"apitestcustomer";
    self.testProduct.product_page_url = @"http://www.jcpenney.com/st-johns-bay-long-sleeve-plaid-flannel-shirt/prod.jump?ppId=pp5005151849";
    self.testProduct.price = @"$36.95";
    self.testProduct.reviewText = @"Lorem Ipsum Jason is all up in yo tests all up in the product recommendations this whole thing is going to be original ain't gonna copy paste NOTHING let's recite pi 3.1415926535894 that's all I got and I dunno if its correct. Pretty confident in for lik 12 digits after the decimal point tho. That was the second period in the review. Third and coming up fourth and last. Just watched an interview with the inspiration for rain man and he memorized like 22500 digits of pi in a couple of weeks and recited it and it took like 5 hours to recite overall this product was 2 stars highly recommend";
    self.testProduct.reviewTitle = @"Great durability";
    self.testProduct.reviewAuthor = @"Jason Harris";
    self.testProduct.reviewAuthorLocation = @"Springfield";
    self.testProduct.avg_rating = @(4.5);
    self.testProduct.num_reviews = @(124);
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