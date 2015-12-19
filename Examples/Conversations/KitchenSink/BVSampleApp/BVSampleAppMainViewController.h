//
//  BVSampleAppMainViewController.h
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import "BVSampleAppResultsViewController.h"
#import <BVSDK/BVConversations.h>

@interface BVSampleAppMainViewController : UIViewController <BVDelegate> {
    BVSampleAppResultsViewController *myResultsView;
}

//Display Classes
- (IBAction)showReview;
- (IBAction)showQuestion;
- (IBAction)showAnswers;
- (IBAction)showStory;
- (IBAction)showComments;
- (IBAction)showProfile;
- (IBAction)showProducts;
- (IBAction)showCateogry;
- (IBAction)showCommentStory;

// Submission classes
- (IBAction)submissionReview;
- (IBAction)submissionQuestions;
- (IBAction)submissionAnswers;
- (IBAction)submissionStories;
- (IBAction)submissionComments;
- (IBAction)submissionPhotos;
- (IBAction)submissionVideos;
- (IBAction)submissionFeedback;
@end