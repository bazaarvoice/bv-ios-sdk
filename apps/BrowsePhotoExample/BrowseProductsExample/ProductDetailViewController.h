//
//  ProductDetailViewController.h
//  RateAndReviewExample
//
//  Created by Bazaarvoice Engineering on 4/23/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//
//  UIViewController for displaying a list of products for a given search
//  term.


#import <UIKit/UIKit.h>
#import "BVIncludes.h"

@interface ProductDetailViewController : UIViewController<BVDelegate, UITableViewDelegate, UITableViewDataSource>

// UIViews for product properties
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

// Table of product reviews
@property (weak, nonatomic) IBOutlet UITableView *reviewsTable;

// External property for passing product data to this view
@property (strong, nonatomic) NSDictionary *productData;
// Internal property for storing product review data
@property (strong, nonatomic) NSArray *reviewsData;

@end
