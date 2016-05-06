//
//  ExtensionShareViewController.swift
//  Curations Custom Post Extension
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social
import BVSDK

// This class demonstrates use of the SLComposeServiceViewController for posting a Curation photo + comment.
class ExtensionShareViewController: BaseDemoComposeServiceViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSDK()
        
        MockDataManager.sharedInstance
    }
    
    // In the event this class is loaded from an extension, the BVSDKManager will be initiazed.
    func configureSDK(){
        
        let mgr = BVSDKManager.sharedManager()
        mgr.setLogLevel(BVLogLevel.Error)
        mgr.staging = CurationsDemoConstants.BVSDK_IS_STAGING;
        mgr.apiKeyCurations = CurationsDemoConstants.API_KEY_CURATIONS
        mgr.clientId = CurationsDemoConstants.CLIENT_ID
        
    }
    
    // User selected to post a photo with a comment
    // In the example below, we just post the photo in the completion request completionHandler so we don't block the UI.
    override func didSelectPost() {
        
        print("didSelectPost")
        
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        if self.extensionContext != nil {

            let contentType = kUTTypeJPEG as String
            let item = self.extensionContext?.inputItems.first as! NSExtensionItem
            
            for attachment in item.attachments as! [NSItemProvider] {
                if attachment.hasItemConformingToTypeIdentifier(contentType) {
                    
                    attachment.loadItemForTypeIdentifier(contentType, options: nil, completionHandler: { (data, error) -> Void in
                        // completion
                        if error == nil {
                            
                            let url = data as! NSURL
                            if let imageData = NSData(contentsOfURL: url) {
                                let selectedImage = UIImage(data: imageData)
                                
                                
                                self.extensionContext!.completeRequestReturningItems([], completionHandler: { (expired) in
                                    
                                    self.postSelectedPhoto(selectedImage!)
                                
                                })
                                
                            }
                            
                        } else {

                            let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .Alert)

                            let action = UIAlertAction(title: "Error", style: .Cancel) { _ in
                                
                                self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                            }
                            
                            alert.addAction(action)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                                        
                }
            }
            
        }
        
    }

    // post the image to curations using an anonymous account
    private func postSelectedPhoto(image: UIImage){
        
        self.postRequest = BVCurationsAddPostRequest(groups: CurationsDemoConstants.DEFAULT_FEED_GROUPS_CURATIONS, withAuthorAlias: "anonymous", withToken: "anon_user", withText: self.textView.text, withImage:image)
        
        let uploadAPI = BVCurationsPhotoUploader()
        
        // Upload the photo with the request!
        uploadAPI.submitCurationsContentWithParams(postRequest, completionHandler: { (void) -> Void in
            
            // Success
            
            print("Photo upload success")
            
            // completion
            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
            
            }) { (error) -> Void in
                
                // Error
                print("Photo upload error: " + error.localizedDescription)
                
                // completion
                self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
        }
        
    }
    

}
