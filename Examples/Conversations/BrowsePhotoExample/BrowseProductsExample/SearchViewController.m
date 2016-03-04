//
//  SearchViewController.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "SearchViewController.h"
#import "ListReviewsController.h"
#import "BVColor.h"

#import <BVSDK/BVConversations.h>

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
    self.navigationController.navigationBar.translucent = NO;
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.navigationController.navigationBar.barTintColor = [BVColor secondaryBrandColor];
    } else {
        self.navigationController.navigationBar.tintColor = [BVColor primaryBrandColor];
    }
    
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
