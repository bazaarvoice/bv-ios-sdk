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

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
    
}

@end
