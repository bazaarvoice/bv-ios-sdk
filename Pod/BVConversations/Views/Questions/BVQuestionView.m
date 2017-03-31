//
//  BVQuestionView.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionView.h"
#import "BVViewsHelper.h"

@implementation BVQuestionView

-(void)setQuestion:(BVQuestion *)question {
    
    _question = question;
    
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
    
}


@end
