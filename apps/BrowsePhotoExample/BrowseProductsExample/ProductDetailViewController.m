//
//  ProductDetailViewController.m
//  RateAndReviewExample
//
//  Created by Bazaarvoice Engineering on 4/23/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ReviewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+Utils.h"
#import "MBProgressHUD.h"
#import "ReviewDetailViewController.h"

@interface ProductDetailViewController ()

// Kicks of the request to fetch reviews for this particular product
- (void)getReviews;
// Sets up the UI to display the appropriate information for this product
- (void)setupProductInfo;
// Utility function for calculating review cell heights
- (CGFloat) heightOfCellWithText:(NSString *)reviewText;

@end

@implementation ProductDetailViewController

@synthesize productTitle = _productTitle;
@synthesize productImage = _productImage;
@synthesize description = _description;
@synthesize reviewsTable = _reviewsTable;
@synthesize productData = _productData;
@synthesize ratingLabel = _ratingLabel;
@synthesize reviewsData = _reviewsData;
@synthesize productRequest = _productRequest;


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
    // Fetch reviews associated with this product
    [self getReviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // This is necessary for the case that the user cancels.  We must set the
    // delegate to nil to avoid callbacks to a dealocated instance.
    self.productRequest.delegate = nil;
}

- (void)getReviews
{
    // Determine the productId of this product for use in our request
    NSString *productId = [self.productData objectForKey:@"Id"];
    
    // Create an SDK request to fetch reviews
    BVDisplayReview *showDisplayRequest = [[BVDisplayReview alloc] init];
    // Params to fetch reviews for a specific product and include stats
    NSString *productIdString = [NSString stringWithFormat:@"ProductId:%@", productId];
    showDisplayRequest.parameters.filter = productIdString;
    showDisplayRequest.parameters.stats = @"Reviews";
    
    // Set up this object as a delegate and kick off the request
    showDisplayRequest.delegate = self;
    self.productRequest = showDisplayRequest;
    [showDisplayRequest startAsynchRequest];
    
    // Show a loading overlay
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) didReceiveResponse:(BVResponse*)response forRequest:(BVBase *)request
{
    // Extract the reviews data from this response and set up the UI to reflec this data.
    self.reviewsData = response.results;
    [self setupProductInfo];
    [self.reviewsTable reloadData];
    
    // Hide the loading overlay
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(BVBase *)request
{
    // Graceful handling of errors is critical.  In this case, we simply display a
    // prompt and pop the user back to the product list
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                      message:@"An error occurred.  Please try again."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
}
- (void) setupProductInfo 
{
    // If we have a product image, display it, otherwise display a default
    if([self.productData objectForKey:@"ImageUrl"])
    {
        [self.productImage setImageWithURL:[self.productData objectForKey:@"ImageUrl"]];        
    } 
    else 
    {
        self.productImage.image = [UIImage imageNamed:@"camera_icon.gif"];
    }
    
    // Title and description
    self.productTitle.text = [self.productData objectForKey:@"Name"];
    self.description.text = [self.productData objectForKey:@"Description"];
    
    // Construct the product review statistics string
    if ([[self.productData objectForKey:@"TotalReviewCount"] intValue] > 0)
    {
        NSDictionary *reviewStatistics = [self.productData objectForKey:@"ReviewStatistics"];
        self.ratingLabel.text = [NSString stringWithFormat:@"Average rating of %@/%@ based on %@ reviews.", [reviewStatistics objectForKey:@"AverageOverallRating"],
                                 [reviewStatistics objectForKey:@"OverallRatingRange"],
                                 [reviewStatistics objectForKey:@"TotalReviewCount"]];
    } 
    else 
    {
        self.ratingLabel.text = @"No reviews yet.  Write one!";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returns the number of reviews for this product
    if(!self.reviewsData)
    {
        return 0;
    } 
    else 
    {
        return self.reviewsData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a review cell
    static NSString *CellIdentifier = @"ReviewCell";
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Extract the specific data for this cell from the reviewsData array
    NSDictionary *cellData = [self.reviewsData objectAtIndex:indexPath.row];

    // Check if we have photos.  If so, use the first as the review icon, otherwise
    // display a placeholder
    NSArray *photos = [cellData objectForKeyNotNull:@"Photos"];
    if(photos && photos.count > 0)
    {
        NSString *url = [[[[photos objectAtIndex:0] objectForKeyNotNull:@"Sizes"] objectForKeyNotNull:@"normal"] objectForKeyNotNull:@"Url"];
        [cell.image setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_icon.gif"]];
    } 
    else 
    {
        cell.image.image = [UIImage imageNamed:@"camera_icon.gif"];
    }
    
    // Other review information
    cell.author.text = [cellData objectForKeyNotNull:@"Title"];
    cell.review.text = [cellData objectForKeyNotNull:@"ReviewText"];
    cell.stars.rating = [[cellData objectForKeyNotNull:@"Rating"] intValue];
    return cell;
}


// This is a UITableViewDelegate method to provide height for a particular cell.
// Since reviews are of different lengths and we wish to display the entire review
// we need to do some special calculations to provide the cell height.  
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = [self.reviewsData objectAtIndex:indexPath.row];
    return [self heightOfCellWithText:[cellData objectForKeyNotNull:@"ReviewText"]];
}

// Helper method for calculating cell height.  Essentially, this figures out how much
// space the review will take and then adds a constant to provide space for the 
// static cell header and padding.
#define HEADER_SIZE 90.0
-(CGFloat) heightOfCellWithText:(NSString *)reviewText
{
    return HEADER_SIZE + [reviewText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(255, 500)].height;
}

#pragma mark - Table view delegate

// Upon selecton of a table row, perform a segue to the review detail view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Extract the specific review data for the review that was selected and pass
    // it to the segue
    NSDictionary *reviewData = [self.reviewsData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"reviewDetail" sender:reviewData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reviewDetail"]) {
        // Pass the specific review data to the ReviewDetailViewController
        ReviewDetailViewController *reviewController = segue.destinationViewController;
        reviewController.reviewData = sender;
    } 
}

- (void)viewDidUnload
{
    [self setProductImage:nil];
    [self setDescription:nil];
    [self setReviewsTable:nil];
    [self setProductTitle:nil];
    [self setRatingLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
