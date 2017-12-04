//
//  BVQuestionCollectionViewCell.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionCollectionViewCell.h"
#import "BVViewsHelper.h"

@implementation BVQuestionCollectionViewCell

- (void)setQuestion:(BVQuestion *)question {

  _question = question;
}

- (void)didMoveToSuperview {

  [super didMoveToSuperview];
  [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
}

@end
