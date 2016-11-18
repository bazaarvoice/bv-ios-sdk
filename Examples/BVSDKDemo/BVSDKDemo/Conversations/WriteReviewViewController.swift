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

class WriteReviewViewController: UIViewController, SDFormDelegate, SDFormDataSource {
    
    let reviewSubmissionParameters = SubmissionParameterHolder()
    
    // For using SDFormField, this demo presumes one field item per section.
    // Hence, the section header will contain the tile, and the row will just contain the widget
    // and any placeholder text
    var formFields : [SDFormField] = []
    var sectionTitles : [String] = []
    
    var form : SDForm?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header : ProductDetailHeaderView!

    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)

    private var product: BVProduct?
    private var productId: String?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product: BVProduct) {
        self.product = product
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, productId: String) {
        self.productId = productId

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.presentingViewController != nil {
            self.navigationController?.navigationBar.isTranslucent = false
            edgesForExtendedLayout = []
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(WriteReviewViewController.dismissSelf))
        }
        
        ProfileUtils.trackViewController(self)
        
        self.title = "Write a Review"
        
        self.view.backgroundColor = UIColor.appBackground()
        
        self.tableView.backgroundColor = UIColor.white
        
        // form scrolling above keyboard
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        
        // add a SUBMIT button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(WriteReviewViewController.submitTapped))
        
        if let prod = product {
            updateProductUI(product: prod)
        }else {
            loadProduct(productId: productId!)
        }
    }
    
    private func loadProduct(productId: String) {
        DispatchQueue.main.async {
            self.spinner.center = self.view.center
            self.view.addSubview(self.spinner)
        }
        let request = BVProductDisplayPageRequest(productId: productId)
            .includeStatistics(.reviews)
            .includeStatistics(.questions)
        request.load({ (response) in
            self.product = response.result
            self.updateProductUI(product: response.result!)
            self.spinner.removeFromSuperview()
        }){(errors) in
        }
    }
    
    private func updateProductUI(product: BVProduct) {
        self.initFormFields()
        header.product = product
    }
    
    func submitTapped() {
        
        // NOTE: This sample doens't do field validation so we let the API do it for us.
        // Typically your UI Controller would do some basic validation and guide your user on the required fields and field lengths.
        
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        
        // create a fill out the reviewSubmission object
        let reviewSubmission = BVReviewSubmission(reviewTitle: self.reviewSubmissionParameters.title as? String ?? "",
                                                reviewText: self.reviewSubmissionParameters.reviewText as? String ?? "",
                                                rating: UInt(self.reviewSubmissionParameters.rating?.intValue ?? 0),
                                                productId: self.product!.identifier!)


        // a working example of posting a review.
        reviewSubmission.action = BVSubmissionAction.preview // Don't actually post, just run in preview mode!
        
        // We need to use the same userId for both the photo post and review content
        let userId = "123abc\(arc4random())"
        
        reviewSubmission.userNickname = self.reviewSubmissionParameters.userNickname as? String
        reviewSubmission.userEmail = self.reviewSubmissionParameters.userEmail as? String
        reviewSubmission.userId = userId
        reviewSubmission.isRecommended = self.reviewSubmissionParameters.isRecommended
        reviewSubmission.sendEmailAlertWhenPublished = self.reviewSubmissionParameters.sendEmailAlertWhenPublished
        reviewSubmission.hostedAuthenticationEmail = self.reviewSubmissionParameters.userEmail as? String
        if let photo = self.reviewSubmissionParameters.photo {
            reviewSubmission.addPhoto(photo, withPhotoCaption: nil)
        }
        
        reviewSubmission.submit({ (response) in
            
            DispatchQueue.main.async(execute: { 
                _ = SweetAlert().showAlert("Success!", subTitle: "Your review was submitted. It may take up to 72 hours before your post is live.", style: .success)
                _ = self.navigationController?.popViewController(animated: true)
            })
            
        }) { (errors) in
            
            DispatchQueue.main.async(execute: {
                _ = SweetAlert().showAlert("Error!", subTitle: errors.first?.localizedDescription, style: .error)
                self.spinner.removeFromSuperview()
            })
            
        }
        
    }
    
    
    func initFormFields(){
        
        let recommendProductSwitch = SDSwitchField(object: reviewSubmissionParameters, relatedPropertyKey: "isRecommended")
        recommendProductSwitch?.title = "I recommend this product."
        
        let ratingStars = SDRatingStarsField(object: reviewSubmissionParameters, relatedPropertyKey: "rating")
        ratingStars?.maximumValue = 5
        ratingStars?.minimumValue = 0
        ratingStars?.starsColor = UIColor.bazaarvoiceGold()
        
        let reviewTitleField = SDTextFormField(object: reviewSubmissionParameters, relatedPropertyKey: "title")
        reviewTitleField?.placeholder = "Add your review title"
        
        let reviewField = SDMultilineTextField(object: reviewSubmissionParameters, relatedPropertyKey: "reviewText")
        reviewField?.placeholder = "Add your thoughts and experinces with this product."
        
        let nickNameField : SDTextFormField = SDTextFormField(object: reviewSubmissionParameters, relatedPropertyKey: "userNickname")
        nickNameField.placeholder = "Display name for the question"
        
        let emailAddressField : SDTextFormField = SDTextFormField(object: reviewSubmissionParameters, relatedPropertyKey: "userEmail")
        emailAddressField.placeholder = "Enter a valid email address."
        
        let emailOKSwitchField = SDSwitchField(object: reviewSubmissionParameters, relatedPropertyKey: "sendEmailAlertWhenPublished")
        emailOKSwitchField?.title = "Send me status by email?"
        
        let photoField = SDPhotoField(object: reviewSubmissionParameters, relatedPropertyKey: "photo")
        photoField?.presentingMode = SDFormFieldPresentingModeModal;
        photoField?.title = "photo"
        let cameraIcon = FAKFontAwesome.cameraIcon(withSize: 22)
        cameraIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray.withAlphaComponent(0.5))
        photoField?.callToActionImage = cameraIcon?.image(with: CGSize(width: 22, height: 22))

        // Keep the formFields and sectionTitles in the same order if you switch them around.
        self.formFields = [recommendProductSwitch!, ratingStars!, reviewTitleField!, reviewField!, nickNameField, emailAddressField, photoField!, emailOKSwitchField!]
        self.sectionTitles = ["", "Rate this product", "Review Title", "Your Review", "Nickname", "Email Address", "Add a photo (optional)", "Please send me an email to keep me informed on the status of my review."]
        
        // set up delegate/datasource last!
        self.form = SDForm(tableView: self.tableView)
        self.form?.delegate = self
        self.form?.dataSource = self
        
    }
    
    func dismissSelf(){
        
        if self.presentingViewController != nil {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: SDKFormDelegate, SDFormDataSource
    

    func form(_ form: SDForm!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        
        let hv = view as! UITableViewHeaderFooterView
        let color = UIColor.white
        hv.tintColor = color
        hv.contentView.backgroundColor = color
        hv.textLabel?.textColor = UIColor.bazaarvoiceNavy()
        
    }
    
    func form(_ form: SDForm!, willDisplayFooterView view: UIView!, forSection section: Int) {
        let fv = view as! UITableViewHeaderFooterView
        fv.contentView.backgroundColor = UIColor.white
    }
    
    func numberOfSections(for form: SDForm!) -> Int {
        return (self.formFields.count)
    }
    
    func form(_ form: SDForm!, numberOfFieldsInSection section: Int) -> Int {
        return 1
    }
    
    func form(_ form: SDForm!, titleForFooterInSection section: Int) -> String! {
        return ""
    }
    
    func form(_ form: SDForm!, titleForHeaderInSection section: Int) -> String! {
        return self.sectionTitles[section]
    }
    
    func form(_ form: SDForm!, fieldForRow row: Int, inSection section: Int) -> SDFormField! {
        
        return self.formFields[section]
        
    }
    
    func viewController(for form: SDForm!) -> UIViewController! {
        return self;
    }


}

@objc class SubmissionParameterHolder : NSObject {
    
    var rating : NSNumber?
    var title : NSString?
    var reviewText : NSString?
    var userNickname : NSString?
    var userEmail : NSString?
    
    var isRecommended:NSNumber?
    var sendEmailAlertWhenPublished:NSNumber?
    
    var photo : UIImage?
    
}
