//
//  SubmitAnswerViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDForms

class SubmitAnswerViewController: BaseUGCViewController, BVDelegate, SDFormDelegate, SDFormDataSource {
    
    let postAnswerParams = BVPost(type: BVPostTypeAnswer)
    
    // For using SDFormField, this demo presumes one field item per section.
    // Hence, the section header will contain the tile, and the row will just contain the widget
    // and any placeholder text
    var formFields : [SDFormField] = []
    var sectionTitles : [String] = []
    
    var form : SDForm?
    
    let selectedQuestion : Question!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, product: BVProduct, question: Question) {
        
        selectedQuestion = question
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, product: product)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Submit an Answer"
        
        // a working example of posting an answer.
        postAnswerParams.action = BVActionPreview // Don't actually post, just run in preview mode!
        
        // We need to use the same userId for answer content
        let userId = "123abc\(arc4random())"
        
        postAnswerParams.questionId = selectedQuestion.questionId
        postAnswerParams.title = ""
        postAnswerParams.answerText = ""
        postAnswerParams.userNickname = ""
        postAnswerParams.userEmail = ""
        postAnswerParams.sendEmailAlertWhenPublished = true
        postAnswerParams.authenticatedUser = userId
        
        // form scrolling above keyboard
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        
        // add a SUBMIT button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submitTapped")
        
        self.initFormFields()
    }
    
    func submitTapped() {
        
        // TODO: Add in field validator here....
        // Otherwise the API will validate for us.
        
        self.spinner.center = self.view.center
        self.view.addSubview(self.spinner)
        
        submitAnswer()
        
    }
    
    func submitAnswer(){
        
        self.tableView.resignFirstResponder()
        
        postAnswerParams.sendRequestWithDelegate(self)
    }
    
    
    func initFormFields(){
        
        let answerField = SDMultilineTextField(object: postAnswerParams, relatedPropertyKey: "answerText")
        answerField.placeholder = "Answer"
        
        let nickNameField : SDTextFormField = SDTextFormField(object: postAnswerParams, relatedPropertyKey: "userNickname")
        nickNameField.placeholder = "Nickname"
        
        let emailAddressField : SDTextFormField = SDTextFormField(object: postAnswerParams, relatedPropertyKey: "userEmail")
        emailAddressField.placeholder = "Enter a valid email address"
        
        let emailOKSwitchField = SDSwitchField(object: postAnswerParams, relatedPropertyKey: "sendEmailAlertWhenPublished")
        emailOKSwitchField.title = "Send me status by email?"
        
        // Keep the formFields and sectionTitles in the same order if you switch them around.
        self.formFields = [answerField, nickNameField, emailAddressField, emailOKSwitchField]
        self.sectionTitles = ["Your Answer", "Your Nickname", "Email Address", "Please send me an email to keep me informed on the status of my answer."]
        
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
        
        if (request as? BVPost) != nil {
            
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
                
                SweetAlert().showAlert("Error Uploading Answer", subTitle: errorMessage, style: .Error)
                
                self.spinner.removeFromSuperview()
                
            } else {
                SweetAlert().showAlert("Success!", subTitle: "Your answer was submitted. It may take up to 72 hours before your post is live.", style: .Success)
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
