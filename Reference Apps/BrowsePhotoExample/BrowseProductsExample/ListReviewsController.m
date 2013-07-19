//
//  ListReviewsController.m
//  RateAndReviewExample
//
//  Created by Bazaarvoice Engineering on 4/23/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "ListReviewsController.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "MBProgressHUD.h"
#import "NSDictionary+Utils.h"

@interface ListReviewsController ()

// This method kicks off the SDK request to fetch products
-(void)getProducts;

@end

@implementation ListReviewsController

@synthesize searchTerm = _searchTerm;
@synthesize tableView = _tableView;
@synthesize productData = _productData;
@synthesize searchRequest = _searchRequest;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Kick off the request to fetch products
    [self getProducts];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

- (void)getProducts 
{
    // Initialize an SDK request to festch products
    BVGet *showDisplayRequest = [[BVGet alloc] initWithType:BVGetTypeProducts];
    // Additional paramters to sort by rating and include associated reviews
    [showDisplayRequest addSortForAttribute:@"AverageOverallRating" ascending:false];
    [showDisplayRequest addStatsOn:BVIncludeStatsTypeReviews];
    // Search query parameter
    showDisplayRequest.search = self.searchTerm;
    // Set up this object as the delegate and kick off the request
    [showDisplayRequest sendRequestWithDelegate:self];
    
    // Show the loading spinner
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) didReceiveResponse:(NSDictionary *)response forRequest:(id)request;
{
    // Store the resulting product data and reload the list of products
    self.productData = [response objectForKey:@"Results"];
    [self.tableView reloadData];
    
    // Hide the loading spinner
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(id)request
{
    // Graceful handling of errors is critical.  In this case, we simply display a
    // prompt and pop the user back to the search screen so that they can submit 
    // again.
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                      message:@"An error occurred.  Please try again."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    // This is necessary for the case that the user cancels.  We must set the
    // delegate to nil to avoid callbacks to a dealocated instance.
    self.searchRequest.delegate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.productData)
    {
        // If we have no data yet, then don't display anything
        return 0;
    } 
    else if (self.productData.count == 0)
    {
        // If we have data, but no products matched this query, display 
        // a row to indicate no products found
        return 1;
    }
    else 
    {
        // Otherwise, display the products
        return self.productData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.productData.count == 0)
    {
        // Display a no products cell if we have product data, but no products
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"No products found.";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    else 
    {
        // Fill in data from the data source to populate our custom cell
        static NSString *CellIdentifier = @"ReviewCell";
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        // Pull the specific NSDictionary for this cell from our product data
        NSDictionary *cellData = [self.productData objectAtIndex:indexPath.row];
        
        // Set the title and description
        cell.title.text = [cellData objectForKey:@"Name"];
        cell.description.text = [cellData objectForKey:@"Description"];
        
        // If we have reviews, then display a star rating, otherwise, display
        // no reviews to incentivise the user to write a review
        if([[cellData objectForKey:@"TotalReviewCount"] intValue] > 0)
        {
            cell.stars.rating = [[[cellData objectForKey:@"ReviewStatistics"] objectForKeyNotNull:@"AverageOverallRating"] doubleValue];
        }
        else 
        {
            cell.stars.noRatings = YES;
        }
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When a row is selected, segue to the detail view
    if(self.productData.count > 0)
    {
        [self performSegueWithIdentifier:@"detail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        // Extract the product data for the selected row and provide it to the product detail screen
        ProductDetailViewController *productController = segue.destinationViewController;
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        productController.productData = [self.productData objectAtIndex:selectedRow];
    }
}


@end
