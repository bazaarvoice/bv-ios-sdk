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

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
    
}

@end
