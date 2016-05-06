//
//  WriteReviewViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDForms
import FontAwesomeKit

class WriteReviewViewController: BaseUGCViewController, BVDelegate, SDFormDelegate, SDFormDataSource {
    
    let postReviewParams = BVPost(type: BVPostTypeReview)
    let postPhotoParams = BVMediaPost(type: BVMediaPostTypePhoto)
    
    // For using SDFormField, this demo presumes one field item per section.
    // Hence, the section header will contain the tile, and the row will just contain the widget
    // and any placeholder text
    var formFields : [SDFormField] = []
    var sectionTitles : [String] = []
    
    var form : SDForm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Write a Review"
        
        // a working example of posting a review.
        postReviewParams.action = BVActionPreview // Don't actually post, just run in preview mode!
        
        // We need to use the same userId for both the photo post and review content
        let userId = "123abc\(arc4random())"
        
        postReviewParams.productId = product.productId
        //postReviewParams.userId = userId
        postReviewParams.rating = 0
        postReviewParams.title = ""
        postReviewParams.reviewText = ""
        postReviewParams.userNickname = ""
        postReviewParams.isRecommended = true
        postReviewParams.userEmail = ""
        postReviewParams.sendEmailAlertWhenPublished = true
        postReviewParams.rating = 0
        postReviewParams.authenticatedUser = userId
        
        // With photo submission, we must explicitly set the content type.
        // In this case, we are uploading a photo to a review
        postPhotoParams.contentType = BVMediaPostContentTypeReview
        postPhotoParams.userId = userId
        
        // form scrolling above keyboard
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        
        // add a SUBMIT button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SUBMIT", style: .Plain, target: self, action: "submitTapped")
        
        self.initFormFields()
    }
    
    func submitTapped() {
        
        // TODO: Add in field validator here....
        // Otherwise the API will validate for us.
        
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        
        // Sumbitting a photo is optional, but if we do have a photo
        // we will make the media post request first for the photo and
        // when that is successful we'll submit the actual review.
        if (postPhotoParams.photo) != nil {
            submitPhoto()
        } else {
            submitReview()
        }
        
    }
    
    func submitReview(){
        
        self.tableView.resignFirstResponder()
        
        postReviewParams.sendRequestWithDelegate(self)
    }
    
    func submitPhoto(){
        
        postPhotoParams.sendRequestWithDelegate(self)

    }
    
    
    func initFormFields(){
        
        let recommendProductSwitch = SDSwitchField(object: postReviewParams, relatedPropertyKey: "isRecommended")
        recommendProductSwitch.title = "I recommend this product."
        
        let ratingStars = SDRatingStarsField(object: postReviewParams, relatedPropertyKey: "rating")
        ratingStars.maximumValue = 5
        ratingStars.minimumValue = 0
        ratingStars.starsColor = UIColor.bazaarvoiceGold()
        
        let reviewTitleField = SDTextFormField(object: postReviewParams, relatedPropertyKey: "title")
        reviewTitleField.placeholder = "Add your review title"
        
        let reviewField = SDMultilineTextField(object: postReviewParams, relatedPropertyKey: "reviewText")
        reviewField.placeholder = "Add your thoughts and experinces with this product."
        
        let nickNameField : SDTextFormField = SDTextFormField(object: postReviewParams, relatedPropertyKey: "userNickname")
        nickNameField.placeholder = "Display name for the question"
        
        let emailAddressField : SDTextFormField = SDTextFormField(object: postReviewParams, relatedPropertyKey: "userEmail")
        emailAddressField.placeholder = "Enter a valid email address."
        
        let emailOKSwitchField = SDSwitchField(object: postReviewParams, relatedPropertyKey: "sendEmailAlertWhenPublished")
        emailOKSwitchField.title = "Send me status by email?"
        
        let photoField = SDPhotoField(object: postPhotoParams, relatedPropertyKey: "photo")
        photoField.presentingMode = SDFormFieldPresentingModeModal;
        photoField.title = "photo"
        let cameraIcon = FAKFontAwesome.cameraIconWithSize(22)
        cameraIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor().colorWithAlphaComponent(0.5))
        photoField.callToActionImage = cameraIcon.imageWithSize(CGSizeMake(22, 22))

        // Keep the formFields and sectionTitles in the same order if you switch them around.
        self.formFields = [recommendProductSwitch, ratingStars, reviewTitleField, reviewField, nickNameField, emailAddressField, photoField, emailOKSwitchField]
        self.sectionTitles = ["", "Rate this product", "Review Title", "Your Review", "Nickname", "Email Address", "Add a photo (optional)", "Please send me an email to keep me informed on the status of my review."]
        
        // set up delegate/datasource last!
        self.form = SDForm(tableView: self.tableView)
        self.form?.delegate = self
        self.form?.dataSource = self
        
    }

    // MARK: BVDelegate
    
    func hasErrors(response: NSDictionary) -> Bool {
        
        return (response.objectForKey("HasErrors") != nil && response.objectForKey("HasErrors")?.boolValue == true)
        
    }
    
    func didReceiveResponse(response: [NSObject : AnyObject]!, forRequest request: AnyObject!) {
        
        if (request as? BVMediaPost) != nil {
            
            // If the photo request has responded, we want to identify the
            // new photo url so that it can be included with the form submission
            
            if (response != nil) {
                
                let responseDict = response as NSDictionary
                
                if self.hasErrors(responseDict) {
                    
                    var errorMessage = ""
                    if responseDict.objectForKey("Errors")!.count > 0{
                        errorMessage = (responseDict.objectForKey("Errors")?.objectAtIndex(0).objectForKey("Message") as? String)!
                    } else {
                        errorMessage = (responseDict.objectForKey("FormErrors")?.objectForKey("FieldErrors")?.objectForKey("photo")?.objectForKey("Message") as? String)!
                    }
                    
                    SweetAlert().showAlert("Error Uploading Photo", subTitle: errorMessage, style: .Error)
                    
                    self.spinner.removeFromSuperview()
                    
                } else {
                    
                    // Successfully uploaded the photo, now sumbit the review portion.
                    
                    let photoUrl = responseDict.objectForKey("Photo")?.objectForKey("Sizes")?.objectForKey("normal")?.objectForKey("Url") as! String
                    print("Photo uploaded to: " + photoUrl)
                    
                    self.postReviewParams.addPhotoUrl(photoUrl, withCaption: nil)
                    
                    self.submitReview()
                
                }

            }
            
        } else if (request as? BVPost) != nil {
            
             let responseDict = response as NSDictionary
            
            if self.hasErrors(responseDict){
                
                var errorMessage = "Unknown error"
                if responseDict.objectForKey("Errors")!.count > 0{
                    errorMessage = (responseDict.objectForKey("Errors")?.objectAtIndex(0).objectForKey("Message") as? String)!
                } else {
                    let fieldErrors = responseDict.objectForKey("FormErrors")?.objectForKey("FieldErrors") as? NSDictionary
                    var summedErrorMessage = ""
                    for (_,value) in fieldErrors! {
                        let message = value.objectForKey("Message") as! String
                        let field = value.objectForKey("Field") as! String
                        summedErrorMessage += field + ": " + message + "\n"
                    }
                    errorMessage = summedErrorMessage
                }
                
                SweetAlert().showAlert("Error Uploading Review", subTitle: errorMessage, style: .Error)
                
                self.spinner.removeFromSuperview()
                
            } else {
                SweetAlert().showAlert("Success!", subTitle: "Your review was submitted. It may take up to 72 hours before your post is live.", style: .Success)
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            self.spinner.removeFromSuperview()
            
        }
    }
    
    func didFailToReceiveResponse(err: NSError!, forRequest request: AnyObject!) {
        // error
        SweetAlert().showAlert("Error!", subTitle: err.localizedDescription, style: .Error)
        self.spinner.removeFromSuperview()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    

    // MARK: SDKFormDelegate, SDFormDataSource
    

    func form(form: SDForm!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        
        let hv = view as! UITableViewHeaderFooterView
        let color = UIColor.whiteColor()
        hv.tintColor = color
        hv.contentView.backgroundColor = color
        hv.textLabel?.textColor = UIColor.bazaarvoiceNavy()
        
    }
    
    func form(form: SDForm!, willDisplayFooterView view: UIView!, forSection section: Int) {
        let fv = view as! UITableViewHeaderFooterView
        fv.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    func numberOfSectionsForForm(form: SDForm!) -> Int {
        return (self.formFields.count)
    }
    
    func form(form: SDForm!, numberOfFieldsInSection section: Int) -> Int {
        return 1
    }
    
    func form(form: SDForm!, titleForFooterInSection section: Int) -> String! {
        return ""
    }
    
    func form(form: SDForm!, titleForHeaderInSection section: Int) -> String! {
        return self.sectionTitles[section]
    }
    
    func form(form: SDForm!, fieldForRow row: Int, inSection section: Int) -> SDFormField! {
        
        return self.formFields[section]
        
    }
    
    func viewControllerForForm(form: SDForm!) -> UIViewController! {
        return self;
    }


}
