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
                                                    productId: "test1")
        
        // a working example of posting a review.
        reviewSubmission.action = BVSubmissionAction.submit // Don't actually post, just run in preview mode!
        
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
        
        reviewSubmission.submit({ (response) in
    
            self.showAlertSuccess(message: "Success Submitting Review!")
            
        }) { (error) in
            
            self.showAlertError(message: error.description)
            
        }

    }

    @IBAction func submitQuestionTapped(sender: AnyObject) {
        
        let submission = BVQuestionSubmission(productId: "test1")
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
        
        let feedback = BVFeedbackSubmission(contentId: "192454", with: BVFeedbackContentType.review, with: BVFeedbackType.helpfulness)
        
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
