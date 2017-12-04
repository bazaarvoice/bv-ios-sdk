//
//  BVAnswerView.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerView.h"
#import "BVViewsHelper.h"

@implementation BVAnswerView

- (void)setAnswer:(BVAnswer *)answer {

  _answer = answer;
}

- (void)didMoveToSuperview {

  [super didMoveToSuperview];
  [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
}

@end
