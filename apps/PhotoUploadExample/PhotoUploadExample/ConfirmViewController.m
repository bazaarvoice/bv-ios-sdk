//
//  ConfirmViewController.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 4/27/12.
//  Copyright (c) 2012 BazaarVoice. All rights reserved.
//

#import "ConfirmViewController.h"
#import "NSDictionary+Utils.h"
#import "ReviewCell.h"

@interface ConfirmViewController ()
- (void)setUpReviewDisplay;
- (void)getReviews;
@end

@implementation ConfirmViewController
@synthesize submitFlash = _submitFlash;
@synthesize rateView = _rateView;
@synthesize reviewsTable = _reviewsTableView;
@synthesize reviewTextView = _reviewTextView;
@synthesize reviewImageView = _reviewImage;
@synthesize confirmData = _confirmData;
@synthesize reviewImage = _previewImage;
@synthesize titleLabel = _titleLabel;
@synthesize reviewsData = _reviewsData;

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
    
    // RateView setup.  Note that in this case, we are merely displaying
    // the star rating, so it is not editable
    self.rateView.notSelectedImage = [UIImage imageNamed:@"empty_star.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    self.rateView.rating = 0;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;
    
    [self setUpReviewDisplay];
    [self getReviews];
}

- (void)setUpReviewDisplay
{
    // Set up the review display for the title, text and rating
    NSDictionary *reviewData = [self.confirmData objectForKeyNotNull:@"Review"];
    self.titleLabel.text = [reviewData objectForKeyNotNull:@"Title"];
    self.reviewTextView.text = [reviewData objectForKeyNotNull:@"ReviewText"];
    self.rateView.rating = [[reviewData objectForKeyNotNull:@"Rating"] floatValue];
}

- (void)getReviews
{
    // We are just going to fake a reviews request for now.  In practice, this would really
    // be a request for the specific product reviewed
    NSString *oldPasskey =  [BVSettings instance].passKey;
    NSString *oldCustomerName = [BVSettings instance].customerName;
    [BVSettings instance].passKey = @"KEY_REMOVED";
    [BVSettings instance].customerName = @"reviews.apitestcustomer"; 
    
    // Create an SDK request to fetch reviews
    BVDisplayReview *showDisplayRequest = [[BVDisplayReview alloc] init];
    // Params to fetch reviews for a specific product and include stats
    NSString *productIdString = [NSString stringWithFormat:@"ProductId:%@", @"1000001"];
    showDisplayRequest.parameters.filter = productIdString;
    showDisplayRequest.parameters.stats = @"Reviews";
    
    // Set up this object as a delegate and kick off the request
    showDisplayRequest.delegate = self;
    [showDisplayRequest startAsynchRequest];
    
    [BVSettings instance].passKey = oldPasskey;
    [BVSettings instance].customerName = oldCustomerName;
}

- (void) didReceiveResponse:(BVResponse*)response forRequest:(BVBase *)request
{
    // Extract the reviews data from this response and set up the UI to reflec this data.
    self.reviewsData = response.results;
    [self.reviewsTable reloadData];
}

- (void) didFailToReceiveResponse:(NSError*)err forRequest:(BVBase *)request
{
    // Graceful handling of errors is critical.  In this case, though, we 
    // can fail silently, since we want to confirm the review regardless.
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
       
    // Other review information
    cell.author.text = [cellData objectForKeyNotNull:@"Title"];
    cell.review.text = [cellData objectForKeyNotNull:@"ReviewText"];
    // RateView setup.  Note that in this case, we are merely displaying
    // the star rating, so it is not editable
    cell.stars.notSelectedImage = [UIImage imageNamed:@"empty_star.png"];
    cell.stars.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    cell.stars.rating = 0;
    cell.stars.editable = NO;
    cell.stars.maxRating = 5;
    cell.stars.rating = [[cellData objectForKeyNotNull:@"Rating"] floatValue];
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
#define HEADER_SIZE 60.0
-(CGFloat) heightOfCellWithText:(NSString *)reviewText
{
    return HEADER_SIZE + [reviewText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(265, 500)].height;
}



- (void)viewDidAppear:(BOOL)animated
{
    // Setup the image preview AFTER the view has appeared and then
    // fade it in.  this isn't strictly necessary, but creates a 
    // smooth animation and is a nice effect.
    self.reviewImageView.alpha = 0;
    self.reviewImageView.image = self.reviewImage;
    [UIView animateWithDuration:1.0
                     animations:^ {
                         self.reviewImageView.alpha = 1;
                     }
     ];

    // Animate out the confirmation flash after a delay
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:1.0];   
    [UIView setAnimationDelay:5.0];
    [self.submitFlash setAlpha:0];
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [self setSubmitFlash:nil];
    [self setTitleLabel:nil];
    [self setReviewImageView:nil];
    [self setRateView:nil];
    [self setTitleLabel:nil];
    [self setReviewTextView:nil];
    [self setReviewsTable:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        return YES;    
    return NO;
}

@end
