//
//  SearchViewController.m
//  BrowseProductsExample
//
//  Created by Bazaarvoice Engineering on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "ListReviewsController.h"

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
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:14/255.0 green:42/255.0 blue:63/255.0 alpha:1];
    
    // Global BV SDK setup.  In general this should only occur once
    [BVSettings instance].passKey = @"kuy3zj9pr3n7i0wxajrzj04xo";
    [BVSettings instance].customerName = @"reviews.apitestcustomer"; 
    [BVSettings instance].dataString = @"bvstaging/data";
    [BVSettings instance].apiVersion = @"5.1";
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
