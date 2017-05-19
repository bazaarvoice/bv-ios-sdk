//
//  MyCommentTableViewCell.m
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "MyCommentTableViewCell.h"

@interface MyCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *commentTitle;
@property (weak, nonatomic) IBOutlet UILabel *commentText;


@end


@implementation MyCommentTableViewCell

@synthesize comment = _comment;

- (void)setComment:(BVComment *)comment{
    
    _comment = comment;
    self.commentTitle.text = self.comment.title ? self.comment.title : @"No title";
    self.commentText.text =  self.comment.commentText ? self.comment.commentText : @"No comment text";
    
}



@end
