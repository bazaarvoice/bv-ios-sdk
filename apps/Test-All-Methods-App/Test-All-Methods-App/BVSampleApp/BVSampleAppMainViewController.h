//
//  BVSampleAppMainViewController.h
//  BVSampleApp
//
//  Created by Bazaarvoice Engineering on 3/10/12.
//  Copyright (c) 2012 Bazaarvoice Inc.. All rights reserved.
//

#import "BVSampleAppFlipsideViewController.h"
#import "BVSampleAppResultsViewController.h"
#import "BVIncludes.h"

@interface BVSampleAppMainViewController : UIViewController <BVSampleAppFlipsideViewControllerDelegate, BVDelegate> {
    BVSampleAppResultsViewController *myResultsView;
}

- (IBAction)showInfo:(id)sender;

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
@end