//
//  MyAnswerTableViewCell.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "MyAnswerTableViewCell.h"

@interface MyAnswerTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *answerTestLabel;

@end

@implementation MyAnswerTableViewCell


- (void)setAnswer:(BVAnswer *)answer{
    
    super.answer = answer;
    self.answerTestLabel.text = answer.answerText;
    
}

@end