//
//  ListReviewsController.h
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//
//  UIViewController for displaying a list of products for a given search
//  term.

#import <UIKit/UIKit.h>
#import <BVSDK/BVSDK.h>

@interface ListReviewsController : UIViewController<UITableViewDelegate, UITableViewDataSource, BVDelegate>

// Array of product data -- this is the data source for the display
@property (strong) NSArray *productData;
// Query term for products  
@property (strong) NSString *searchTerm;
// Table view
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) BVGet *searchRequest;
@end
