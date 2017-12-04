//
//  AuthorViewController.m
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "AuthorViewController.h"
#import "MyAnswerTableViewCell.h"
#import "MyQuestionTableViewCell.h"
#import "MyReviewTableViewCell.h"
#import "StatisticTableViewCell.h"

@import BVSDK;

typedef enum {
  ProfileStats = 0,
  IncludedReviews,
  IncludedQuestions,
  IncludedAnswers,
  SectionCount // Keep last to keep the section count
} AuthorSections;

@interface AuthorViewController ()

@property(weak, nonatomic) IBOutlet UITableView *authorProfileTableView;
@property(strong, nonatomic) BVAuthorResponse *authorResponse;

@end

@implementation AuthorViewController

- (void)viewDidLoad {

  [super viewDidLoad];

  self.authorProfileTableView.estimatedRowHeight = 44;
  self.authorProfileTableView.rowHeight = UITableViewAutomaticDimension;
  [self.authorProfileTableView
                 registerNib:[UINib nibWithNibName:@"StatisticTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"StatisticTableViewCell"];
  [self.authorProfileTableView
                 registerNib:[UINib nibWithNibName:@"MyReviewTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"MyReviewTableViewCell"];
  [self.authorProfileTableView
                 registerNib:[UINib nibWithNibName:@"MyQuestionTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"MyQuestionTableViewCell"];
  [self.authorProfileTableView
                 registerNib:[UINib nibWithNibName:@"MyAnswerTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"MyAnswerTableViewCell"];

  NSString *authorId = @"data-gen-user-c3k8hjvtpn03dupvxcui1rj3";
  // NSString *authorId = @"data-gen-user-3aykphgodq0ng2i2jwk67b7fy";
  // NSString *authorId = @"data-gen-user-2eiqsoaxkf78m8knj5hp9pj7l";

  BVAuthorRequest *request =
      [[BVAuthorRequest alloc] initWithAuthorId:authorId];
  [request includeStatistics:BVAuthorContentTypeReviews];
  [request includeStatistics:BVAuthorContentTypeQuestions];
  [request includeStatistics:BVAuthorContentTypeAnswers];
  [request includeContent:BVAuthorContentTypeReviews limit:5];
  [request includeContent:BVAuthorContentTypeQuestions limit:5];
  [request includeContent:BVAuthorContentTypeAnswers limit:5];

  [request load:^(BVAuthorResponse *_Nonnull response) {

    // Success!
    NSLog(@"Succesfully loaded profile: %@", response);
    self.authorResponse = response;
    [_authorProfileTableView reloadData];

  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {

        // Error : (
        NSLog(@"ERROR loading author: %@", errors.description);

      }];
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return SectionCount;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {

  switch (section) {
  case ProfileStats:
    return @"Author Profile Stats";
    break;
  case IncludedReviews:
    return @"Included Reviews";
    break;
  case IncludedQuestions:
    return @"Included Questions";
    break;
  case IncludedAnswers:
    return @"Included Answers";
    break;
  default:
    break;
  }

  return @"";
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  if (!self.authorResponse)
    return 0;

  BVAuthor *author = self.authorResponse.results.firstObject;

  switch (section) {
  case ProfileStats:
    return
        [self.authorResponse.totalResults integerValue]; // should always be 1
    break;
  case IncludedReviews:
    return author.includedReviews != nil ? author.includedReviews.count : 0;
    break;
  case IncludedQuestions:
    return author.includedQuestions != nil ? author.includedQuestions.count : 0;
    break;
  case IncludedAnswers:
    return author.includedAnswers != nil ? author.includedAnswers.count : 0;
    break;
  default:
    break;
  }

  return 0;
}

- (NSString *)createAuthorStatsString:(BVAuthor *)author {

  if (!author)
    return @"No author stats.";

  NSString *summaryText =
      [NSString stringWithFormat:@"Stats for: %@\n", author.userNickname];

  if (author.userLocation) {
    summaryText = [summaryText
        stringByAppendingFormat:@"Location: %@\n", author.userLocation];
  }

  if (author.reviewStatistics) {
    summaryText = [summaryText
        stringByAppendingFormat:@"Reviews (%@)\n",
                                author.reviewStatistics.totalReviewCount];
  }

  if (author.qaStatistics) {
    summaryText = [summaryText
        stringByAppendingFormat:@"Questions (%@)\n",
                                author.qaStatistics.totalQuestionCount];
    summaryText = [summaryText
        stringByAppendingFormat:@"Answers (%@)\n",
                                author.qaStatistics.totalAnswerCount];
  }

  if (author.contextDataValues) {
    summaryText = [summaryText
        stringByAppendingFormat:@"Context Data Values (%lu) ",
                                (unsigned long)author.contextDataValues.count];

    for (BVContextDataValue *contextData in author.contextDataValues) {
      summaryText = [summaryText stringByAppendingFormat:@"[%@:%@]",
                                                         contextData.identifier,
                                                         contextData.value];
    }

    summaryText = [summaryText stringByAppendingString:@"\n"];
  }

  if (author.badges) {
    summaryText = [summaryText
        stringByAppendingFormat:@"Badges (%lu) ",
                                (unsigned long)author.badges.count];

    for (BVBadge *badge in author.badges) {
      summaryText =
          [summaryText stringByAppendingFormat:@"[%@:%@]", badge.identifier,
                                               badge.contentType];
    }

    summaryText = [summaryText stringByAppendingString:@"\n"];
  }

  return summaryText;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  BVAuthor *author = self.authorResponse.results.firstObject;

  switch (indexPath.section) {

  case ProfileStats: {
    StatisticTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"StatisticTableViewCell"];
    cell.statTypeLabel.text = @"Author Statistics";
    cell.statValueLabel.text = [self createAuthorStatsString:author];
    return cell;
  } break;
  case IncludedReviews: {
    MyReviewTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"MyReviewTableViewCell"];
    cell.review = [author.includedReviews objectAtIndex:indexPath.row];
    return cell;
  } break;
  case IncludedQuestions: {
    MyQuestionTableViewCell *cell = [tableView
        dequeueReusableCellWithIdentifier:@"MyQuestionTableViewCell"];
    cell.question = [author.includedQuestions objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
  } break;
  case IncludedAnswers: {
    MyAnswerTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"MyAnswerTableViewCell"];
    cell.answer = [author.includedAnswers objectAtIndex:indexPath.row];
    return cell;
  } break;
  default:
    break;
  }

  return nil;
}

@end
