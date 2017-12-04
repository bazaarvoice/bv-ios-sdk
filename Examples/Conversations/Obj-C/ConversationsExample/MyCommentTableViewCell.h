//
//  MyCommentTableViewCell.h
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@import BVSDK;

@interface MyCommentTableViewCell : UITableViewCell

@property(nonatomic, strong) BVComment *comment;

@end
