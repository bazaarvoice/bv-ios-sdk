//
//  AskAQuestionViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDForms

class AskAQuestionViewController: UIViewController, SDFormDelegate, SDFormDataSource {

    var form : SDForm?
    
    // For using SDFormField, this demo presumes one field item per section.
    // Hence, the section header will contain the tile, and the row will just contain the widget
    // and any placeholder text
    var formFields : [SDFormField] = []
    var sectionTitles : [String] = []
    
    var questionSubmissionParameters = QuestionSubmissionParamsHolder()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header : ProductDetailHeaderView!
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
    let product: BVRecommendedProduct
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product: BVRecommendedProduct?) {
        self.product = product!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileUtils.trackViewController(self)
        
        self.title = "Ask a Question!"
        header.product = product
        
        self.view.backgroundColor = UIColor.appBackground()
        self.tableView.backgroundColor = UIColor.white
        
        // add a submit button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(AskAQuestionViewController.submitTapped))
        
        // form scrolling above keyboard
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        
        self.initFormFields()
    
    }
    
    func initFormFields(){
        
        let questionField = SDMultilineTextField(object: self.questionSubmissionParameters, relatedPropertyKey: "questionSummary")
        questionField?.placeholder = "Example: How do I get replacement bolts?"
        
        let moreDetailsField = SDMultilineTextField(object: self.questionSubmissionParameters, relatedPropertyKey: "questionDetails")
        moreDetailsField?.placeholder = "Example: I have looked at the manual and can't figure out what I'm doing wrong."
        
        let nickNameField : SDTextFormField = SDTextFormField(object: self.questionSubmissionParameters, relatedPropertyKey: "userNickname")
        nickNameField.placeholder = "Display name for the question"
        
        let emailAddressField : SDTextFormField = SDTextFormField(object: self.questionSubmissionParameters, relatedPropertyKey: "userEmail")
        emailAddressField.placeholder = "Enter a valid email address."
        
        let emailOKSwitchField = SDSwitchField(object: self.questionSubmissionParameters, relatedPropertyKey: "sendEmailAlertWhenPublished")
        emailOKSwitchField?.title = "Send me status by email?"
        
        let agreeTermsAndConditions = SDSwitchField(object: self.questionSubmissionParameters, relatedPropertyKey: "agreedToTermsAndConditions")
        agreeTermsAndConditions?.title = "Agree?"
        
        // Keep the formFields and sectionTitles in the same order if you switch them around.
        self.formFields = [questionField!, moreDetailsField!, nickNameField, emailAddressField, emailOKSwitchField!, agreeTermsAndConditions!]
        self.sectionTitles = ["Question", "More Details (optional)", "Nickname", "Email address", "May we contact you at this email address?", "Do you agree to the Terms & Conditions?"]
        
        // set up delegate/datasource last!
        self.form = SDForm(tableView: self.tableView)
        self.form?.delegate = self
        self.form?.dataSource = self
        
    }

    func submitTapped() {
        
        // TODO: Add in field validator here....
        // Otherwise the API will validate for us.
        
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        
        self.tableView.resignFirstResponder()
        
        // Submit the question
        
        let submission = BVQuestionSubmission(productId: product.productId)
        submission.action = .preview // don't actually just submit for real, this is just for demo
        submission.questionSummary = self.questionSubmissionParameters.questionSummary as? String
        submission.questionDetails = self.questionSubmissionParameters.questionDetails as? String
        submission.userNickname = self.questionSubmissionParameters.userNickname as? String
        submission.userEmail = self.questionSubmissionParameters.userEmail as? String
        submission.sendEmailAlertWhenPublished = self.questionSubmissionParameters.sendEmailAlertWhenPublished
        submission.agreedToTermsAndConditions = self.questionSubmissionParameters.agreedToTermsAndConditions
        
        submission.submit({ (response) in
            
            DispatchQueue.main.async(execute: { 
                _ = SweetAlert().showAlert("Success!", subTitle: "Your question was submitted. It may take up to 72 hours for us to respond.", style: .success)
                _ = self.navigationController?.popViewController(animated: true)
            })
            
        }) { (errors) in
            
            DispatchQueue.main.async(execute: {
                var errorMessage = ""
                for error in errors {
                    errorMessage += "\(error)."
                }
                
                _ = SweetAlert().showAlert("Error Sumbitting Question", subTitle: errorMessage, style: .error)
                
                self.spinner.removeFromSuperview()
            })
            
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
    
    func numberOfSections(for form: SDForm!) -> Int {
        return (self.formFields.count)
    }
    
    func form(_ form: SDForm!, numberOfFieldsInSection section: Int) -> Int {
        return 1
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

@objc class QuestionSubmissionParamsHolder : NSObject {
    
    var questionSummary : NSString?
    var questionDetails : NSString?
    var userNickname : NSString?
    var userEmail : NSString?
    
    var sendEmailAlertWhenPublished:NSNumber?
    var agreedToTermsAndConditions:NSNumber?
    
}
