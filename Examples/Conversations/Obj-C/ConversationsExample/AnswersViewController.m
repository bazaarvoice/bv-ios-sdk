//
//  AnswersViewController.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "AnswersViewController.h"
#import "MyAnswerTableViewCell.h"

@interface AnswersViewController () <UITableViewDataSource>

@property(weak, nonatomic) IBOutlet BVAnswersTableView *answersTableView;

@end

@implementation AnswersViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.answersTableView.dataSource = self;
  self.answersTableView.estimatedRowHeight = 44;
  self.answersTableView.rowHeight = UITableViewAutomaticDimension;
  [self.answersTableView
                 registerNib:[UINib nibWithNibName:@"MyAnswerTableViewCell"
                                            bundle:nil]
      forCellReuseIdentifier:@"MyAnswerTableViewCell"];
}

#pragma mark UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return @"Questions Responses";
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.question.includedAnswers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  MyAnswerTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"MyAnswerTableViewCell"];

  cell.answer = [self.question.includedAnswers objectAtIndex:indexPath.row];

  return cell;
}

@end
