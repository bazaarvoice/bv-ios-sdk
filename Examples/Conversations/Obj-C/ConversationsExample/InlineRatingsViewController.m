//
//  InlineRatingsViewController.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "InlineRatingsViewController.h"
#import "StatisticTableViewCell.h"

@interface InlineRatingsViewController () <UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *inlineReviewsTableView;
@property NSArray<BVProductStatistics *> *productStatistics;

@end

@implementation InlineRatingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.productStatistics = [NSArray array];

  self.inlineReviewsTableView.dataSource = self;
  self.inlineReviewsTableView.dataSource = self;
  self.inlineReviewsTableView.estimatedRowHeight = 68;
  self.inlineReviewsTableView.rowHeight = UITableViewAutomaticDimension;
  [self.inlineReviewsTableView
                 registerNib:[UINib nibWithNibName:@"StatisticTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"StatisticTableViewCell"];

  NSArray *productIds =
      @[ @"test1", @"test2", @"test3", @"test4", @"test5", @"test6" ];

  BVBulkRatingsRequest *request = [[BVBulkRatingsRequest alloc]
      initWithProductIds:productIds
              statistics:BVBulkRatingIncludeTypeValueBulkRatingAll];

  [request load:^(BVBulkRatingsResponse *_Nonnull response) {
    self.productStatistics = response.results;
    [self.inlineReviewsTableView reloadData];
  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        NSLog(@"ERROR: %@", errors.description);
      }];
}

#pragma mark UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return @"Inline Review Responses";
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.productStatistics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  StatisticTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"StatisticTableViewCell"];

  cell.statTypeLabel.text = [NSString
      stringWithFormat:@"Product ID: %@",
                       [self.productStatistics objectAtIndex:indexPath.row]
                           .productId];
  long totalReivewCount = [[self.productStatistics objectAtIndex:indexPath.row]
                               .reviewStatistics.totalReviewCount longValue];
  long averageOverallRating =
      [[self.productStatistics objectAtIndex:indexPath.row]
              .reviewStatistics.averageOverallRating longValue];
  long overallRatingRange =
      [[self.productStatistics objectAtIndex:indexPath.row]
              .reviewStatistics.overallRatingRange longValue];

  cell.statValueLabel.text =
      [NSString stringWithFormat:@"Total Reivew Count: %ld\nAverage Overall "
                                 @"Rating: %ld\nOverall Rating Range: %ld",
                                 totalReivewCount, averageOverallRating,
                                 overallRatingRange];

  return cell;
}

//    cell.statValueLabel.text = "Total Review
//    Count(\(productStatistics[indexPath.row].reviewStatistics!.totalReviewCount!.stringValue)),
//    \nAverage Overall
//    Rating(\(productStatistics[indexPath.row].reviewStatistics!.averageOverallRating!.stringValue)),
//    \nOverall Rating
//    Range(\(productStatistics[indexPath.row].reviewStatistics!.overallRatingRange!.stringValue))
//    "
//
//    return cell
//}

@end
