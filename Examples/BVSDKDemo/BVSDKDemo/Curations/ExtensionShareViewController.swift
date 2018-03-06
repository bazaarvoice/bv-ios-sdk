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
    
    _ = MockDataManager.sharedInstance
  }
  
  // In the event this class is loaded from an extension, the BVSDKManager will be initiazed.
  func configureSDK(){
    
    let mgr = BVSDKManager.shared()
    mgr.setLogLevel(BVLogLevel.error)
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
          
          attachment.loadItem(forTypeIdentifier: contentType, options: nil, completionHandler: { (data, error) -> Void in
            // completion
            if error == nil {
              
              let url = data as! URL
              if let imageData = try? Data(contentsOf: url) {
                let selectedImage = UIImage(data: imageData)
                
                
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: { (expired) in
                  
                  self.postSelectedPhoto(selectedImage!)
                  
                })
                
              }
              
            } else {
              
              let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
              
              let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
              }
              
              alert.addAction(action)
              self.present(alert, animated: true, completion: nil)
            }
          })
          
        }
      }
      
    }
    
  }
  
  // post the image to curations using an anonymous account
  private func postSelectedPhoto(_ image: UIImage){
    
    self.postRequest = BVCurationsAddPostRequest(groups: CurationsDemoConstants.DEFAULT_FEED_GROUPS_CURATIONS, withAuthorAlias: "anonymous", withToken: "anon_user", withText: self.textView.text, with:image)
    
    let uploadAPI = BVCurationsPhotoUploader()
    
    // Upload the photo with the request!
    uploadAPI.submitCurationsContent(withParams: postRequest, completionHandler: { (void) -> Void in
      
      // Success
      
      print("Photo upload success")
      
      // completion
      self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
      
    }) { (error) -> Void in
      
      // Error
      print("Photo upload error: " + (error.localizedDescription))
      
      // completion
      self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
  }
  
  
}
