//
//  RootViewController.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "RootViewController.h"
@import BVSDK;

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (IBAction)submitReviewTapped:(id)sender {

  BVReviewSubmission *review = [[BVReviewSubmission alloc]
      initWithReviewTitle:@"Review title goes here"
               reviewText:@"Review text goes here. Super cali fragilistic "
                          @"expiali docious!!!"
                   rating:4
                productId:@"test1"];

  review.userId = [NSString
      stringWithFormat:@"userId%d", arc4random()]; // add in a random user id
                                                   // for testing, avoids
                                                   // duplicate errors
  review.action = BVSubmissionActionPreview;
  review.userNickname = @"shazbat";
  review.userEmail = @"foo@bar.com";
  review.sendEmailAlertWhenPublished = [NSNumber numberWithBool:YES];
  review.agreedToTermsAndConditions = [NSNumber numberWithBool:YES];

  // user added a photo to this review
  [review addPhoto:[UIImage imageNamed:@"puppy"]
      withPhotoCaption:@"What a cute pupper!"];

  [review submit:^(BVReviewSubmissionResponse *_Nonnull response) {
    [self showSuccess:@"Success Submitting Review!"];
  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        [self showError:errors.description];
      }];
}

- (IBAction)submitQuestionTapped:(id)sender {

  BVQuestionSubmission *question =
      [[BVQuestionSubmission alloc] initWithProductId:@"test1"];
  question.action = BVSubmissionActionPreview;

  NSString *randomId = [NSString stringWithFormat:@"userId%u", arc4random()];

  question.questionSummary = @"Question Summary";
  question.questionDetails = @"Question details...";
  question.userEmail = @"foo@bar.com";
  question.userNickname = [NSString stringWithFormat:@"UserNick%@", randomId];
  question.userId = [NSString stringWithFormat:@"UserId%@", randomId];
  question.sendEmailAlertWhenPublished = [NSNumber numberWithBool:YES];
  question.agreedToTermsAndConditions = [NSNumber numberWithBool:YES];

  [question submit:^(BVQuestionSubmissionResponse *_Nonnull response) {
    [self showSuccess:@"Success Submitting Question!"];
  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        [self showError:errors.description];
      }];
}

- (IBAction)submitAnswerTapped:(id)sender {

  BVAnswerSubmission *answer = [[BVAnswerSubmission alloc]
      initWithQuestionId:@"14679"
              answerText:@"User answer text goes here...."];
  answer.action = BVSubmissionActionPreview;

  NSString *randomId = [NSString stringWithFormat:@"userId%u", arc4random()];

  answer.userEmail = @"foo@bar.com";
  answer.userNickname = [NSString stringWithFormat:@"UserNick%@", randomId];
  answer.userId = [NSString stringWithFormat:@"UserId%@", randomId];
  answer.sendEmailAlertWhenPublished = [NSNumber numberWithBool:YES];
  answer.agreedToTermsAndConditions = [NSNumber numberWithBool:YES];

  [answer submit:^(BVAnswerSubmissionResponse *_Nonnull response) {
    [self showSuccess:@"Success Submitting Answer!"];
  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        [self showError:errors.description];
      }];
}

- (IBAction)submitFeedbackTapped:(id)sender {

  BVFeedbackSubmission *feedback = [[BVFeedbackSubmission alloc]
      initWithContentId:@"192451"
        withContentType:BVFeedbackContentTypeReview
       withFeedbackType:BVFeedbackTypeHelpfulness];

  feedback.userId = [NSString
      stringWithFormat:@"userId%d", arc4random()]; // add in a random user id
                                                   // for testing, avoids
                                                   // duplicate errors
  feedback.vote = BVFeedbackVotePositive;

  [feedback submit:^(BVFeedbackSubmissionResponse *_Nonnull response) {
    // success
    [self showSuccess:@"Success Submitting Feedback!"];
  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        // error
        [self showError:errors.description];
      }];
}

- (IBAction)submitReviewCommentTapped:(id)sender {

  NSString *commentText = @"I love comments almost as much as Objective-C! "
                          @"They are just the most! Seriously!";
  NSString *commentTitle = @"Comments Can We Written In Objective-C";

  BVCommentSubmission *submission =
      [[BVCommentSubmission alloc] initWithReviewId:@"192550"
                                    withCommentText:commentText];

  NSString *randomId = [NSString stringWithFormat:@"userId%u", arc4random()];

  // commentRequest.fingerPrint = // the iovation fingerprint would go here...
  submission.action = BVSubmissionActionPreview;
  submission.campaignId = @"BV_COMMENT_CAMPAIGN_ID";
  submission.commentTitle = commentTitle;
  submission.locale = @"en_US";
  submission.sendEmailAlertWhenPublished = [NSNumber numberWithBool:YES];
  submission.userNickname = [NSString stringWithFormat:@"UserNick%@", randomId];
  submission.userId = [NSString stringWithFormat:@"UserId%@", randomId];
  submission.userEmail = @"developer@bazaarvoice.com";
  submission.agreedToTermsAndConditions = [NSNumber numberWithBool:YES];

  // user added a photo to this review
  //[submission addPhoto:[UIImage imageNamed:@"puppy"] withPhotoCaption:@"What a
  // cute pupper!"];

  [submission submit:^(BVCommentSubmissionResponse *_Nonnull response) {
    // success
    [self showSuccess:@"Success Submitting Feedback!"];
  }
      failure:^(NSArray<NSError *> *_Nonnull errors) {
        // error
        [self showError:errors.description];
      }];
}

- (void)showSuccess:(NSString *)message {

  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Success"
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *okButon =
      [UIAlertAction actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                             handler:nil];
  [alert addAction:okButon];

  [self presentViewController:alert animated:YES completion:nil];
}

- (void)showError:(NSString *)message {

  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Error"
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *okButon =
      [UIAlertAction actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                             handler:nil];
  [alert addAction:okButon];

  [self presentViewController:alert animated:YES completion:nil];
}

@end
