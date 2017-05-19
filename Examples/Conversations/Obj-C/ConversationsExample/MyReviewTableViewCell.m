//
//  MyReviewTableViewCell.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "MyReviewTableViewCell.h"

@interface MyReviewTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *reviewTitle;
@property (weak, nonatomic) IBOutlet UILabel *reviewText;

@end

@implementation MyReviewTableViewCell


- (void)setReview:(BVReview *)review{
    
    super.review = review;
    self.reviewTitle.text = review.title;
    self.reviewText.text = review.reviewText;

}

@end
