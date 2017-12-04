//
//  CommentsViewController.m
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "CommentsViewController.h"
#import "BVComment.h"
#import "MyCommentTableViewCell.h"

@interface CommentsViewController () <UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *commentsTableView;

@property NSArray<BVComment *> *comments;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.comments = [NSArray array];

  self.commentsTableView.dataSource = self;
  self.commentsTableView.estimatedRowHeight = 44;
  self.commentsTableView.rowHeight = UITableViewAutomaticDimension;
  [self.commentsTableView
                 registerNib:[UINib nibWithNibName:@"MyCommentTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"MyCommentTableViewCell"];

  BVCommentsRequest *request =
      [[BVCommentsRequest alloc] initWithReviewId:@"192548" limit:99 offset:0];

  [request load:^(BVCommentsResponse *_Nonnull response) {
    // success
    self.comments = response.results;
    [self.commentsTableView reloadData];

  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        // error
        NSLog(@"ERROR Loading Comments: %@",
              errors.firstObject.localizedDescription);
      }];
}

#pragma mark UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return @"Comments";
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  MyCommentTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"MyCommentTableViewCell"];

  cell.comment = [self.comments objectAtIndex:indexPath.row];

  return cell;
}

@end
