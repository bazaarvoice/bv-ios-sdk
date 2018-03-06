//
//  RootViewController.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class RootViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.barTintColor = UIColor.white
    self.navigationController?.navigationBar.isTranslucent = false
    
  }
  
  @IBAction func submitReviewTapped(sender: AnyObject) {
    
    let reviewSubmission = BVReviewSubmission(reviewTitle: "Review Title",
                                              reviewText: "Review text...This needs to be long enough to be accepted.",
                                              rating: 5,
                                              productId: Constants.TEST_PRODUCT_ID)
    
    // a working example of posting a review.
    reviewSubmission.action = BVSubmissionAction.preview // Don't actually post, just run in preview mode!
    
    // We need to use the same userId for both the photo post and review content
    let userId = "123abc\(arc4random())"
    
    reviewSubmission.userNickname = userId
    reviewSubmission.userEmail = "foo@bar.com"
    reviewSubmission.userId = userId
    reviewSubmission.isRecommended = true
    reviewSubmission.sendEmailAlertWhenPublished = true
    
    if let photo = UIImage(named: "puppy"){
      reviewSubmission.addPhoto(photo, withPhotoCaption: "5 star pup!")
    }
    
    // add youtube video link, if your configuration supports it
    reviewSubmission.addVideoURL("https://www.youtube.com/watch?v=oHg5SJYRHA0", withCaption: "All your wildest dreams will come true.")
    
    reviewSubmission.submit({ (response) in
      
      self.showAlertSuccess(message: "Success Submitting Review!")
      
    }) { (error) in
      
      self.showAlertError(message: error.description)
      
    }
    
  }
  
  @IBAction func submitQuestionTapped(sender: AnyObject) {
    
    let submission = BVQuestionSubmission(productId: Constants.TEST_PRODUCT_ID)
    submission.action = .preview // don't actually just submit for real, this is just for demo
    submission.questionSummary = "Question Summary"
    submission.questionDetails = "Question details..."
    submission.userEmail = "foo@bar.com"
    let userId = "123abc\(arc4random())"
    submission.userId = userId
    submission.userNickname = userId
    submission.sendEmailAlertWhenPublished = true
    submission.agreedToTermsAndConditions = true
    
    submission.submit({ (response) in
      
      self.showAlertSuccess(message: "Success Submitting Question!")
      
    }) { (error) in
      
      self.showAlertError(message: error.description)
    }
    
  }
  
  @IBAction func submitAnswerTapped(sender: AnyObject) {
    
    let submission = BVAnswerSubmission(questionId: "14679", answerText: "User answer text goes here....")
    submission.action = .preview // Don't actually post, just run in preview mode!
    submission.userEmail = "foo@bar.com"
    submission.sendEmailAlertWhenPublished = true
    let userId = "123abc\(arc4random())"
    submission.userId = userId
    submission.userNickname = userId
    
    submission.submit({ (response) in
      
      self.showAlertSuccess(message: "Success Submitting Answer!")
      
    }) { (error) in
      
      self.showAlertError(message: error.description)
      
    }
    
  }
  
  @IBAction func submitFeedbackTapped(sender: AnyObject) {
    
    let feedback = BVFeedbackSubmission(contentId: "192451", with: BVFeedbackContentType.review, with: BVFeedbackType.helpfulness)
    
    let randomId = String(arc4random())
    
    feedback.userId = "userId" + randomId
    feedback.vote = BVFeedbackVote.positive
    
    feedback.submit({ (response) in
      // success
      self.showAlertSuccess(message: "Success Submitting Feedback!")
      
    }) { (errors) in
      // error
      self.showAlertError(message: errors.description)
    }
    
  }
  
  @IBAction func submitReviewCommentTapped(sender: AnyObject) {
    
    let commentText = "I love comments! They are just the most! Seriously!"
    let commentTitle = "Best Comment Title Ever!"
    let commentRequest = BVCommentSubmission(reviewId: "192548", withCommentText: commentText)
    
    commentRequest.action = .preview
    
    let randomId = String(arc4random()) // create a random id for testing only
    
    //commentRequest.fingerPrint = // the iovation fingerprint would go here...
    commentRequest.campaignId = "BV_COMMENT_CAMPAIGN_ID"
    commentRequest.commentTitle = commentTitle
    commentRequest.locale = "en_US"
    commentRequest.sendEmailAlertWhenPublished = true
    commentRequest.userNickname = "UserNickname" + randomId
    commentRequest.userId = "UserId" + randomId
    commentRequest.userEmail = "developer@bazaarvoice.com"
    commentRequest.agreedToTermsAndConditions = true
    
    // Some PRR clients may support adding photos, check your configuration
    //        if let photo = UIImage(named: "puppy"){
    //            commentRequest.addPhoto(photo, withPhotoCaption: "Review Comment Pupper!")
    //        }
    
    commentRequest.submit({ (commentSubmission) in
      
      // success
      self.showAlertSuccess(message: "Success Submitting Review Comment!")
      
    }, failure: { (errors) in
      // error
      self.showAlertError(message: errors.description)
      
    })
    
  }
  
  
  func showAlertSuccess(message : String){
    
    let alert = UIAlertController(title: "Success!", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func showAlertError(message : String){
    
    let alert = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
}
