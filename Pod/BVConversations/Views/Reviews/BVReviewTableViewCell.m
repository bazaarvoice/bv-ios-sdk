//
//  BVReviewsTableViewCells.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewTableViewCell.h"
#import "BVViewsHelper.h"

@implementation BVReviewTableViewCell

-(void)setReview:(BVReview *)review {
    
    _review = review;
    
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
}

@end
