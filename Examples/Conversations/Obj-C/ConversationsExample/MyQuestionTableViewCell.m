//
//  MyQuestionTableViewCell.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "MyQuestionTableViewCell.h"

@interface MyQuestionTableViewCell ()

@property(weak, nonatomic) IBOutlet UILabel *questionSummary;
@property(weak, nonatomic) IBOutlet UILabel *questionDetails;

@end

@implementation MyQuestionTableViewCell

- (void)setQuestion:(BVQuestion *)question {

  super.question = question;
  self.questionSummary.text =
      [NSString stringWithFormat:@"%@ (%lu Answers)", question.questionSummary,
                                 (unsigned long)question.includedAnswers.count];
  self.questionDetails.text = question.questionDetails;
}

@end
