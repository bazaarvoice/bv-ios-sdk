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
  var paramDict: NSMutableDictionary = [:]
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var header : ProductDetailHeaderView!
  var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
  let product: BVProduct
  
  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product: BVProduct?) {
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
    self.initParameterDictionary()
    self.initFormFields()
    
  }
    func initParameterDictionary() {
        var questionSummary : NSString?
        var questionDetails : NSString?
        var userNickname : NSString?
        var userEmail : NSString?
        var sendEmailAlertWhenPublished:NSNumber?
        var agreedToTermsAndConditions:NSNumber?
        
        self.paramDict.setValue(questionSummary, forKey: "questionSummary")
        self.paramDict.setValue(questionDetails, forKey: "questionDetails")
        self.paramDict.setValue(userNickname, forKey: "userNickname")
        self.paramDict.setValue(userEmail, forKey: "userEmail")
        self.paramDict.setValue(sendEmailAlertWhenPublished, forKey: "sendEmailAlertWhenPublished")
        self.paramDict.setValue(agreedToTermsAndConditions, forKey: "agreedToTermsAndConditions")
    }
    
  func initFormFields(){
    
    let questionField = SDMultilineTextField(object: self.paramDict, relatedPropertyKey: "questionSummary")
    questionField?.placeholder = "Example: How do I get replacement bolts?"
    
    let moreDetailsField = SDMultilineTextField(object: self.paramDict, relatedPropertyKey: "questionDetails")
    moreDetailsField?.placeholder = "Example: I have looked at the manual and can't figure out what I'm doing wrong."
    
    let nickNameField : SDTextFormField = SDTextFormField(object: self.paramDict, relatedPropertyKey: "userNickname")
    nickNameField.placeholder = "Display name for the question"
    
    let emailAddressField : SDTextFormField = SDTextFormField(object: self.paramDict, relatedPropertyKey: "userEmail")
    emailAddressField.placeholder = "Enter a valid email address."
    
    let emailOKSwitchField = SDSwitchField(object: self.paramDict, relatedPropertyKey: "sendEmailAlertWhenPublished")
    emailOKSwitchField?.title = "Send me status by email?"
    
    let agreeTermsAndConditions = SDSwitchField(object: self.paramDict, relatedPropertyKey: "agreedToTermsAndConditions")
    agreeTermsAndConditions?.title = "Agree?"
    
    // Keep the formFields and sectionTitles in the same order if you switch them around.
    self.formFields = [questionField!, moreDetailsField!, nickNameField, emailAddressField, emailOKSwitchField!, agreeTermsAndConditions!]
    self.sectionTitles = ["Question", "More Details (optional)", "Nickname", "Email address", "May we contact you at this email address?", "Do you agree to the Terms & Conditions?"]
    
    // set up delegate/datasource last!
    self.form = SDForm(tableView: self.tableView)
    self.form?.delegate = self
    self.form?.dataSource = self
    
  }
  
    @objc func submitTapped() {
    
    // TODO: Add in field validator here....
    // Otherwise the API will validate for us.
    
    self.spinner.center = self.view.center
    self.view.addSubview(self.spinner)
    
    self.tableView.resignFirstResponder()
    
    // Submit the question
    
    let submission = BVQuestionSubmission(productId: product.identifier)
    submission.action = .preview // don't actually just submit for real, this is just for demo
    submission.questionSummary = self.paramDict.value(forKey: "questionSummary") as? String
    submission.questionDetails = self.paramDict.value(forKey: "questionDetails") as? String
    submission.userNickname = self.paramDict.value(forKey: "userNickname") as? String
    submission.userEmail = self.paramDict.value(forKey: "userEmail") as? String
    submission.sendEmailAlertWhenPublished = self.paramDict.value(forKey: "sendEmailAlertWhenPublished") as? NSNumber
    submission.agreedToTermsAndConditions = self.paramDict.value(forKey: "agreedToTermsAndConditions") as? NSNumber
    
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
