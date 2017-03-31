//
//  BVAnswerCollectionViewCell.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerCollectionViewCell.h"
#import "BVViewsHelper.h"

@implementation BVAnswerCollectionViewCell

-(void)setAnswer:(BVAnswer*) answer {
    
    _answer = answer;
    
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
    
}

@end
