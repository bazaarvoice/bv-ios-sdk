//
//  PDPViewController.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "PDPViewController.h"
#import "StatisticTableViewCell.h"

typedef enum { ReviewStats = 0, QAStats, StatSectionsCount } StatSections;

typedef enum {
  TotalReviewCount = 0,
  AverageOverallRating,
  HelpfulVoteCount,
  NotHelpfulVoteCount,
  RecommendedCount,
  NotRecommendedCount,
  OverallRatingRange,
  ReviewStateRowsCount
} ReviewStateRows;

typedef enum {
  TotalQuestions = 0,
  TotalAnswers,
  AnswerHelpfulVoteCount,
  AnswerNotHelpfulVoteCount,
  QuestionHelpfulVoteCount,
  QuestionNotHelpfulVoteCount,
  QAStatRowsCount
} QAStatRows;

@interface PDPViewController () <UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *demoStatsTableView;

@property BVReviewStatistics *reviewStatistics;
@property BVQAStatistics *questionAnswerStats;

@end

@implementation PDPViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.demoStatsTableView.estimatedRowHeight = 80;
  self.demoStatsTableView.rowHeight = UITableViewAutomaticDimension;
  [self.demoStatsTableView
                 registerNib:[UINib nibWithNibName:@"StatisticTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"StatisticTableViewCell"];

  BVProductDisplayPageRequest *request =
      [[BVProductDisplayPageRequest alloc] initWithProductId:@"test1"];
  [request includeStatistics:PDPContentTypeReviews];
  [request includeStatistics:PDPContentTypeAnswers];
  [request includeStatistics:PDPContentTypeQuestions];
  [request includeContent:PDPContentTypeQuestions limit:10];
  [request sortIncludedQuestions:BVSortOptionQuestionsTotalAnswerCount
                           order:BVSortOrderDescending];

  [request load:^(BVProductsResponse *_Nonnull response) {

    self.reviewStatistics = response.result.reviewStatistics;
    self.questionAnswerStats = response.result.qaStatistics;
    [self.demoStatsTableView reloadData];

  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        NSLog(@"ERROR: %@", errors.description);
      }];
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return StatSectionsCount;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  switch (section) {
  case ReviewStats:
    return @"Product Review Statistics";
    break;
  case QAStats:
    return @"Product Question & Answer Statistics";
    break;

  default:
    break;
  }

  return @"";
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  switch (section) {
  case ReviewStats:
    return ReviewStateRowsCount;
    break;
  case QAStats:
    return QAStatRowsCount;
    break;
  default:
    break;
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  StatisticTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"StatisticTableViewCell"];

  switch (indexPath.section) {
  case ReviewStats:

    // Review stats
    switch (indexPath.row) {
    case TotalReviewCount:
      cell.statTypeLabel.text = @"Total Review Count";
      cell.statValueLabel.text =
          [self.reviewStatistics.totalReviewCount stringValue];
      break;

    case AverageOverallRating:
      cell.statTypeLabel.text = @"Average Overall Rating";
      cell.statValueLabel.text =
          [self.reviewStatistics.averageOverallRating stringValue];
      break;

    case HelpfulVoteCount:
      cell.statTypeLabel.text = @"Helpful Vote Count";
      cell.statValueLabel.text =
          [self.reviewStatistics.helpfulVoteCount stringValue];
      break;

    case NotHelpfulVoteCount:
      cell.statTypeLabel.text = @"Not Helpful Vote Count";
      cell.statValueLabel.text =
          [self.reviewStatistics.notHelpfulVoteCount stringValue];
      break;

    case RecommendedCount:
      cell.statTypeLabel.text = @"Recommended Count";
      cell.statValueLabel.text =
          [self.reviewStatistics.recommendedCount stringValue];
      break;

    case NotRecommendedCount:
      cell.statTypeLabel.text = @"Not Recommended Count";
      cell.statValueLabel.text =
          [self.reviewStatistics.notRecommendedCount stringValue];
      break;

    case OverallRatingRange:
      cell.statTypeLabel.text = @"Overall Rating Range";
      cell.statValueLabel.text =
          [self.reviewStatistics.overallRatingRange stringValue];
      break;

    default:
      break;
    }

    break;

  case QAStats:

    switch (indexPath.row) {
    case TotalQuestions:
      cell.statTypeLabel.text = @"Total Questions";
      cell.statValueLabel.text =
          [self.questionAnswerStats.totalQuestionCount stringValue];
      break;

    case TotalAnswers:
      cell.statTypeLabel.text = @"Total Answers";
      cell.statValueLabel.text =
          [self.questionAnswerStats.totalAnswerCount stringValue];
      break;

    case AnswerHelpfulVoteCount:
      cell.statTypeLabel.text = @"Answer Helpful Vote Count";
      cell.statValueLabel.text =
          [self.questionAnswerStats.answerHelpfulVoteCount stringValue];
      break;

    case AnswerNotHelpfulVoteCount:
      cell.statTypeLabel.text = @"Answer Not Helpful Vote Count";
      cell.statValueLabel.text =
          [self.questionAnswerStats.answerNotHelpfulVoteCount stringValue];
      break;

    case QuestionHelpfulVoteCount:
      cell.statTypeLabel.text = @"Question Helpful Vote Count";
      cell.statValueLabel.text =
          [self.questionAnswerStats.questionHelpfulVoteCount stringValue];
      break;

    case QuestionNotHelpfulVoteCount:
      cell.statTypeLabel.text = @"Question Not Helpful Vote Count";
      cell.statValueLabel.text =
          [self.questionAnswerStats.questionNotHelpfulVoteCount stringValue];
      break;

    default:
      break;
    }

    break;

  default:
    break;
  }

  return cell;
}

@end
