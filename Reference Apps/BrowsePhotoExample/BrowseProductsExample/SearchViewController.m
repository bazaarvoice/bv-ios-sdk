//
//  SearchViewController.m
//  BrowseProductsExample
//
//  Created by Bazaarvoice Engineering on 4/26/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "SearchViewController.h"
#import "ListReviewsController.h"
#import "BVColor.h"


#import <BVSDK/BVSDK.h>

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchBox = _searchBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [BVColor primaryBrandColor];
    
    // Global BV SDK setup.  In general this should only occur once
    [BVSettings instance].passKey = @"KEY_REMOVED";
    [BVSettings instance].baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
    [BVSettings instance].staging = YES;
    
    UIImage *image = [UIImage imageNamed:@"graphic-star.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    self.navigationController.navigationItem.titleView = imageView;
    
    self.navigationController.navigationBar.alpha = .8;
}

// Click handler for search button
- (IBAction)performSearch:(id)sender
{
    // Perform segue to display screen
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"search"]) 
    {
        ListReviewsController *listController = segue.destinationViewController;
        // Pass the search term to the ListReviewController to perform query
        listController.searchTerm = self.searchBox.text;
    }
}



- (void)viewDidUnload
{
    [self setSearchBox:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
