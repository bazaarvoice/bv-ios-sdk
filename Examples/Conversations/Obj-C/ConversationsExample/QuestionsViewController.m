//
//  QuestionsViewController.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "QuestionsViewController.h"
#import "AnswersViewController.h"
#import "MyQuestionTableViewCell.h"

@import BVSDK;

@interface QuestionsViewController () <UITableViewDataSource,
                                       UITableViewDelegate>

@property(weak, nonatomic) IBOutlet BVQuestionsTableView *questionsTableView;

@property NSArray<BVQuestion *> *questions;

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.questions = [NSArray array];

  self.questionsTableView.dataSource = self;
  self.questionsTableView.estimatedRowHeight = 44;
  self.questionsTableView.rowHeight = UITableViewAutomaticDimension;
  [self.questionsTableView
                 registerNib:[UINib nibWithNibName:@"MyQuestionTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"MyQuestionTableViewCell"];

  BVQuestionsAndAnswersRequest *request =
      [[BVQuestionsAndAnswersRequest alloc] initWithProductId:@"test1"
                                                        limit:20
                                                       offset:0];
  // optionally add in a sort option
  [request addQuestionSort:BVSortOptionQuestionsLastModeratedTime
                     order:BVSortOrderDescending];
  // optionally add in a filter
  [request addFilter:BVQuestionFilterTypeHasAnswers
      filterOperator:BVFilterOperatorEqualTo
               value:@"true"];

  [self.questionsTableView load:request
      success:^(BVQuestionsAndAnswersResponse *_Nonnull response) {
        self.questions = response.results;
        [self.questionsTableView reloadData];
      }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        NSLog(@"Error loading quesitons");
      }];
}

#pragma mark UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return @"Questions Responses";
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  MyQuestionTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"MyQuestionTableViewCell"];

  cell.question = [self.questions objectAtIndex:indexPath.row];

  return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  BVQuestion *question = [self.questions objectAtIndex:indexPath.row];

  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  AnswersViewController *answersVC =
      [sb instantiateViewControllerWithIdentifier:@"AnswersViewController"];
  answersVC.question = question;

  [self.navigationController pushViewController:answersVC animated:YES];
}

@end
