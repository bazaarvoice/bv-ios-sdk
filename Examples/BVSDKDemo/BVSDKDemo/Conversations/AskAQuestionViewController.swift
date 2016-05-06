//
//  AskAQuestionViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDForms

class AskAQuestionViewController: BaseUGCViewController, SDFormDelegate, SDFormDataSource, BVDelegate {

    var form : SDForm?
    
    // For using SDFormField, this demo presumes one field item per section.
    // Hence, the section header will contain the tile, and the row will just contain the widget
    // and any placeholder text
    var formFields : [SDFormField] = []
    var sectionTitles : [String] = []
    
    var questionParameters = BVPost(type: BVPostTypeQuestion)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Ask a Question!"
        
        // add a SUBMIT button...
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Done, target: self, action: "submitTapped")
        
        // form scrolling above keyboard
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
        
        // init BVPost params
        questionParameters!.action = BVActionPreview // don't actually just submit for real, this is just for demo
        questionParameters!.productId = product.productId
        questionParameters!.locale = "en_US"
        questionParameters!.userId = ""
        questionParameters!.questionSummary = ""
        questionParameters!.questionDetails = ""
        questionParameters!.sendEmailAlertWhenPublished = true
        questionParameters!.agreedToTermsAndConditions = false
        
        self.initFormFields()
    
    }
    
    func initFormFields(){
        
        let questionField = SDMultilineTextField(object: self.questionParameters, relatedPropertyKey: "questionSummary")
        questionField.placeholder = "Example: How do I get replacement bolts?"
        
        let moreDetailsField = SDMultilineTextField(object: self.questionParameters, relatedPropertyKey: "questionDetails")
        moreDetailsField.placeholder = "Example: I have looked at the manual and can't figure out what I'm doing wrong."
        
        let nickNameField : SDTextFormField = SDTextFormField(object: self.questionParameters, relatedPropertyKey: "userNickname")
        nickNameField.placeholder = "Display name for the question"
        
        let emailAddressField : SDTextFormField = SDTextFormField(object: self.questionParameters, relatedPropertyKey: "userEmail")
        emailAddressField.placeholder = "Enter a valid email address."
        
        let emailOKSwitchField = SDSwitchField(object: self.questionParameters, relatedPropertyKey: "sendEmailAlertWhenPublished")
        emailOKSwitchField.title = "Send me status by email?"
        
        let agreeTermsAndConditions = SDSwitchField(object: self.questionParameters, relatedPropertyKey: "agreedToTermsAndConditions")
        agreeTermsAndConditions.title = "Agree?"
        
        // Keep the formFields and sectionTitles in the same order if you switch them around.
        self.formFields = [questionField, moreDetailsField, nickNameField, emailAddressField, emailOKSwitchField, agreeTermsAndConditions]
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
        
        // a working example of posting a review.
        // still the antiquated SDK, but it works :P
        
        self.questionParameters!.sendRequestWithDelegate(self)
        
    }
    
    // MARK: BVDelegate
    
    func hasErrors(response: NSDictionary) -> Bool {
        
        return (response.objectForKey("HasErrors") != nil && response.objectForKey("HasErrors")?.boolValue == true)
        
    }
    
    func didReceiveResponse(response: [NSObject : AnyObject]!, forRequest request: AnyObject!) {
        
        let responseDict = response as NSDictionary
        
        if (self.hasErrors(responseDict)){
            
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
            
            SweetAlert().showAlert("Error Sumbitting Question", subTitle: errorMessage, style: .Error)
            
            self.spinner.removeFromSuperview()
            
            
        } else {
            
            SweetAlert().showAlert("Success!", subTitle: "Your question was submitted. It may take up to 72 hours for us to respond.", style: .Success)
             self.navigationController?.popViewControllerAnimated(true)
            
        }
        
        self.spinner.removeFromSuperview()
        
    }
    
    func didFailToReceiveResponse(err: NSError!, forRequest request: AnyObject!) {
        // error
        SweetAlert().showAlert("Error!", subTitle: err.localizedDescription, style: .Error)
        self.spinner.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
