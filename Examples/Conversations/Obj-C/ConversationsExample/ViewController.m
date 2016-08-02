//
//  ViewController.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"
#import "MyReviewTableViewCell.h"

@import BVSDK;

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BVReviewsTableView *reviewsTableView;

@property NSArray<BVReview *> *reviews;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reviews = [NSArray array];
    
    self.reviewsTableView.dataSource = self;
    self.reviewsTableView.estimatedRowHeight = 44;
    self.reviewsTableView.rowHeight = UITableViewAutomaticDimension;
    [self.reviewsTableView registerNib:[UINib nibWithNibName:@"MyReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyReviewTableViewCell"];
    
    BVReviewsRequest* request = [[BVReviewsRequest alloc] initWithProductId:@"test1" limit:20 offset:0];
    [self.reviewsTableView load:request success:^(BVReviewsResponse * _Nonnull response) {
        self.reviews = response.results;
        [self.reviewsTableView reloadData];
    } failure:^(NSArray<NSError *> * _Nonnull errors) {
        NSLog(@"Error loading reviews");
    }];

}


#pragma mark UITableViewDatasource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Review Responses";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyReviewTableViewCell"];

    cell.review = [self.reviews objectAtIndex:indexPath.row];

    return cell;
}


@end
