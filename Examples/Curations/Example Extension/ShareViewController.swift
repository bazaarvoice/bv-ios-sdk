//
//  ShareViewController.swift
//  Curations Demo Application
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import Social
import BVSDK

let SPINNER_HEIGHT_WIDTH : CGFloat = 200.0

// This class demonstrates using a custom SLComposeServiceViewController within an application to post a comment and photo to Curations.
class ShareViewController: BaseDemoComposeServiceViewController {

    let spinner = Util.createSpinner(UIColor.bazaarvoiceTeal(), size: CGSizeMake(SPINNER_HEIGHT_WIDTH, SPINNER_HEIGHT_WIDTH), padding: 50)
    
    var onDismissComplete: (() -> Void)?

    override func didSelectCancel() {
       self.dismissSelf()
    }
    
    override func didSelectPost() {
        
        if (!CurationsDemoConstants.isSDKConfigured()){
            SweetAlert().showAlert("BVSDK not configured!", subTitle: "You need to add your Curations API key and Clinet ID to test this feature.", style: AlertStyle.Error)
            self.dismissSelf()
            return
        }

        postRequest?.text = self.textView.text
        
        super.didSelectPost()
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        if self.extensionContext != nil {
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        } else {
            
            self.spinner.frame.origin = CGPointMake(self.view.frame.width/2 - SPINNER_HEIGHT_WIDTH/2, self.view.frame.height/4)
            self.view.addSubview(self.spinner)
            
            // completion
            let uploadAPI = BVCurationsPhotoUploader()
            
            // Upload the photo with the request!
            uploadAPI.submitCurationsContentWithParams(self.postRequest, completionHandler: { (void) -> Void in
                
                // Success
                
                self.spinner.removeFromSuperview()
                
                SweetAlert().showAlert("Success!", subTitle: "Your photo was successfully submitted and is pending approval. Please allow up to 72 hours for your photo to appear on our website.", style: AlertStyle.Success, buttonTitle: "OK", action: { (isOtherButton) -> Void in
                    
                    // completion
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        if let callback = self.onDismissComplete {
                            callback ()
                        }
                    })
                    
                })
                
                }) { (error) -> Void in
                    
                    // Error
                    self.spinner.removeFromSuperview()
                    SweetAlert().showAlert("Error Submitting Photo!", subTitle: error.localizedDescription, style: AlertStyle.Error, buttonTitle: "OK", action: { (isOtherButton) -> Void in
                        
                        // completion
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            if let callback = self.onDismissComplete {
                                callback ()
                            }
                        })
                        
                    })
                    
            }
           
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let aliasConfigItem = SLComposeSheetConfigurationItem()
        aliasConfigItem.title = "Username"
        aliasConfigItem.value = self.postRequest?.alias
        
// Example how you might navigate to a UIViewController with an edit field...
//        aliasConfigItem.tapHandler = {
//            
//            let aliasEditViewController = UIViewController()
//            aliasEditViewController.navigationController?.title = "Alias"
//            
//            let textField = UITextField(frame: CGRectMake(10,10,self.view.frame.width - 50,50))
//            textField.borderStyle = UITextBorderStyle.RoundedRect;
//            textField.placeholder = "enter your alias";
//            textField.keyboardType = UIKeyboardType.Default;
//            textField.returnKeyType = UIReturnKeyType.Done;
//            aliasEditViewController.view.addSubview(textField)
//            
//            self.pushConfigurationViewController(aliasEditViewController)
//        }
        
        return [aliasConfigItem]
    }

   
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let handler = self.onDismissComplete {
                handler ()
            }
        })
    }

    
}
