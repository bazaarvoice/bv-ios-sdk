//
//  SubmitAnswerViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDForms

class SubmitAnswerViewController: UIViewController, SDFormDelegate, SDFormDataSource {
    
    var answerSubmissionParameters = AnswerSubmissionParamsHolder()
    
    // For using SDFormField, this demo presumes one field item per section.
    // Hence, the section header will contain the tile, and the row will just contain the widget
    // and any placeholder text
    var formFields : [SDFormField] = []
    var sectionTitles : [String] = []
    
    var form : SDForm?
    
    let selectedQuestion : BVQuestion!
    let product : BVRecommendedProduct
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header : ProductDetailHeaderView!
    var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSizeMake(44,44), padding: 0)
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, product: BVRecommendedProduct, question: BVQuestion) {
        
        selectedQuestion = question
        self.product = product
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileUtils.trackViewController(self)
        
        self.title = "Submit an Answer"
        
        header.product = product
        
        self.view.backgroundColor = UIColor.appBackground()
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        
        // form scrolling above keyboard
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        
        // add a SUBMIT button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submitTapped")
        
        self.initFormFields()
    }
    
    func submitTapped() {
        
        // NOTE: This sample doens't do field validation so we let the API do it for us.
        // Typically your UI Controller would do some basic validation and guide your user on the required fields and field lengths.
        
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        self.tableView.resignFirstResponder()
        
        let submission = BVAnswerSubmission(questionId: selectedQuestion.identifier ?? "", answerText: answerSubmissionParameters.answerText as? String ?? "")
        submission.action = .Preview // Don't actually post, just run in preview mode!
        submission.userNickname = answerSubmissionParameters.userNickname as? String
        submission.userEmail = answerSubmissionParameters.userEmail as? String
        submission.sendEmailAlertWhenPublished = answerSubmissionParameters.sendEmailAlertWhenPublished
        let userId = "123abc\(arc4random())"
        submission.userId = userId
        
        submission.submit({ (response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                SweetAlert().showAlert("Success!", subTitle: "Your answer was submitted. It may take up to 72 hours for us to respond.", style: .Success)
                self.navigationController?.popViewControllerAnimated(true)
            })

        }) { (errors) in
                
            dispatch_async(dispatch_get_main_queue(), {
                var errorMessage = ""
                for error in errors {
                    errorMessage += "\(error)."
                }
                
                SweetAlert().showAlert("Error Sumbitting Question", subTitle: errorMessage, style: .Error)
                
                self.spinner.removeFromSuperview()
            })

        }   
        
    }
    
    
    func initFormFields(){
        
        let answerField = SDMultilineTextField(object: answerSubmissionParameters, relatedPropertyKey: "answerText")
        answerField.placeholder = "Answer"
        
        let nickNameField : SDTextFormField = SDTextFormField(object: answerSubmissionParameters, relatedPropertyKey: "userNickname")
        nickNameField.placeholder = "Nickname"
        
        let emailAddressField : SDTextFormField = SDTextFormField(object: answerSubmissionParameters, relatedPropertyKey: "userEmail")
        emailAddressField.placeholder = "Enter a valid email address"
        
        let emailOKSwitchField = SDSwitchField(object: answerSubmissionParameters, relatedPropertyKey: "sendEmailAlertWhenPublished")
        emailOKSwitchField.title = "Send me status by email?"
        
        // Keep the formFields and sectionTitles in the same order if you switch them around.
        self.formFields = [answerField, nickNameField, emailAddressField, emailOKSwitchField]
        self.sectionTitles = ["Your Answer", "Your Nickname", "Email Address", "Please send me an email to keep me informed on the status of my answer."]
        
        // set up delegate/datasource last!
        self.form = SDForm(tableView: self.tableView)
        self.form?.delegate = self
        self.form?.dataSource = self
        
    }
    
    // MARK: SDKFormDelegate, SDFormDataSource
    
    func form(form: SDForm!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        
        let hv = view as! UITableViewHeaderFooterView
        hv.tintColor = UIColor.whiteColor()
        hv.contentView.backgroundColor = UIColor.whiteColor()
        hv.textLabel?.textColor = UIColor.bazaarvoiceNavy()
        
    }
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let fv = view as! UITableViewHeaderFooterView
        fv.tintColor = UIColor.whiteColor()
        fv.frame.size.height = 0
    }
    
    func numberOfSectionsForForm(form: SDForm!) -> Int {
        return (self.formFields.count)
    }
    
    func form(form: SDForm!, numberOfFieldsInSection section: Int) -> Int {
        return 1
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

@objc class AnswerSubmissionParamsHolder : NSObject {
    
    var answerText : NSString?
    var userNickname : NSString?
    var userEmail : NSString?
    var sendEmailAlertWhenPublished:NSNumber?
    
}
