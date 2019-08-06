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
    
  // For using SDFormField, this demo presumes one field item per section.
  // Hence, the section header will contain the tile, and the row will just contain the widget
  // and any placeholder text
  var formFields : [SDFormField] = []
  var sectionTitles : [String] = []
  var paramDict: NSMutableDictionary = [:]

  
  var form : SDForm?
  
  let selectedQuestion : BVQuestion!
  let product : BVProduct
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var header : ProductDetailHeaderView!
  var spinner = Util.createSpinner(UIColor.bazaarvoiceNavy(), size: CGSize(width: 44,height: 44), padding: 0)
  
  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, product: BVProduct, question: BVQuestion) {
    
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
    
    self.tableView.backgroundColor = UIColor.white
    
    // form scrolling above keyboard
    self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
    
    // add a SUBMIT button...
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(SubmitAnswerViewController.submitTapped))
    
    self.initParameterDictionary()
    self.initFormFields()
  }
  
    @objc func submitTapped() {
    
    // NOTE: This sample doens't do field validation so we let the API do it for us.
    // Typically your UI Controller would do some basic validation and guide your user on the required fields and field lengths.
    
    self.spinner.center = self.view.center
    self.view.addSubview(self.spinner)
    self.tableView.resignFirstResponder()
    
    let submission = BVAnswerSubmission(questionId: selectedQuestion.identifier ?? "", answerText:self.paramDict.value(forKey: "answerText") as? String ?? "")
    submission.action = .preview // Don't actually post, just run in preview mode!
    submission.userNickname = self.paramDict.value(forKey: "userNickname") as? String
    submission.userEmail = self.paramDict.value(forKey: "userEmail") as? String
    submission.sendEmailAlertWhenPublished = self.paramDict.value(forKey: "sendEmailAlertWhenPublished") as? NSNumber
    let userId = "123abc\(arc4random())"
    submission.userId = userId
    
    submission.submit({ (response) in
      
      DispatchQueue.main.async(execute: {
        _ = SweetAlert().showAlert("Success!", subTitle: "Your answer was submitted. It may take up to 72 hours for us to respond.", style: .success)
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
  
    func initParameterDictionary() {
        var answerText : NSString?
        var userNickname : NSString?
        var userEmail : NSString?
        var sendEmailAlertWhenPublished:NSNumber?
        
        self.paramDict.setValue(answerText, forKey: "answerText")
        self.paramDict.setValue(userNickname, forKey: "userNickname")
        self.paramDict.setValue(userEmail, forKey: "userEmail")
        self.paramDict.setValue(sendEmailAlertWhenPublished, forKey: "sendEmailAlertWhenPublished")
    }
  
  func initFormFields(){
    
    let answerField = SDMultilineTextField(object: self.paramDict, relatedPropertyKey: "answerText")
    answerField?.placeholder = "Answer"
    
    let nickNameField : SDTextFormField = SDTextFormField(object: self.paramDict, relatedPropertyKey: "userNickname")
    nickNameField.placeholder = "Nickname"
    
    let emailAddressField : SDTextFormField = SDTextFormField(object: self.paramDict, relatedPropertyKey: "userEmail")
    emailAddressField.placeholder = "Enter a valid email address"
    
    let emailOKSwitchField = SDSwitchField(object: self.paramDict, relatedPropertyKey: "sendEmailAlertWhenPublished")
    emailOKSwitchField?.title = "Send me status by email?"
    
    // Keep the formFields and sectionTitles in the same order if you switch them around.
    self.formFields = [answerField!, nickNameField, emailAddressField, emailOKSwitchField!]
    self.sectionTitles = ["Your Answer", "Your Nickname", "Email Address", "Please send me an email to keep me informed on the status of my answer."]
    
    // set up delegate/datasource last!
    self.form = SDForm(tableView: self.tableView)
    self.form?.delegate = self
    self.form?.dataSource = self
    
  }
  
  // MARK: SDKFormDelegate, SDFormDataSource
  
  func form(_ form: SDForm!, willDisplayHeaderView view: UIView!, forSection section: Int) {
    
    let hv = view as! UITableViewHeaderFooterView
    hv.tintColor = UIColor.white
    hv.contentView.backgroundColor = UIColor.white
    hv.textLabel?.textColor = UIColor.bazaarvoiceNavy()
    
  }
  
  private func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    let fv = view as! UITableViewHeaderFooterView
    fv.tintColor = UIColor.white
    fv.frame.size.height = 0
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
