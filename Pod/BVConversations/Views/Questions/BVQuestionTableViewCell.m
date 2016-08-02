//
//  BVQuestionTableViewCell.m
//  BVConersations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionTableViewCell.h"
#import "BVViewsHelper.h"

@implementation BVQuestionTableViewCell

-(void)setQuestion:(BVQuestion *)question {
    
    _question = question;
    
}

- (void)clicked {
    
    if (_question){
        [_question recordTap];
    }
    
}


- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [BVViewsHelper checkButtonsInSubviews:self.subviews withTarget:self withSelector:@selector(clicked)];
    [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
    
}

@end
