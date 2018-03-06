//
//  BVAnswerTableViewCell.m
//  BVConersations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerTableViewCell.h"
#import "BVViewsHelper.h"

@implementation BVAnswerTableViewCell

- (void)setAnswer:(BVAnswer *)answer {

  _answer = answer;
}

- (void)didMoveToSuperview {

  [super didMoveToSuperview];
  [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
}

@end
