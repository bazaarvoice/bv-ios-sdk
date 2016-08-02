//
//  BVReviewView.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewView.h"
#import "BVViewsHelper.h"

@implementation BVReviewView

-(void)setReview:(BVReview *)review {
    
    _review = review;
    
}

- (void)clicked {
    
    if (_review){
        [_review recordTap];
    }
    
}


- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [BVViewsHelper checkButtonsInSubviews:self.subviews withTarget:self withSelector:@selector(clicked)];
    [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
    
}

@end
