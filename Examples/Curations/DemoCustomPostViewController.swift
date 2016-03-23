//
//  DemoCustomPostViewController.swift
//  Curations Demo App
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

/** This subclassed UIViewController provides a wrapper around a UIImagePickerController and ShareViewController (subclassed from SLComposeServiceViewController).
*/
class DemoCustomPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let shareRequest : BVCurationsAddPostRequest?
    var imagePicker = UIImagePickerController()
    var placeholderText : String = ""
    
    init(shareRequest: BVCurationsAddPostRequest, placeholderText : String) {
        self.shareRequest = shareRequest
        self.placeholderText = placeholderText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.isBeingPresented()){
            self.uploadPhoto()
        }
    }
    
    func uploadPhoto(){
        
        if Platform.isSimulator {
            
            self.selectPhotoFromGallery()
            
        } else {
            
            let optionsMenu = UIAlertController(title: nil, message: "Choose a photo source...", preferredStyle: .ActionSheet)
            
            let closure = { (action: UIAlertAction!) -> Void in
                
                let index : Int = optionsMenu.actions.indexOf(action)!
                
                switch index {
                    
                case 0:
                    self.selectPhotoFromCamera()
                    
                case 1:
                    self.selectPhotoFromGallery()
                    
                case 2:
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

                default:
                    // ignored
                    break
                    
                }
                
            }
            
            optionsMenu.addAction(UIAlertAction(title: "Camera", style: .Default, handler: closure))
            optionsMenu.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: closure))
            optionsMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: closure))
            
            self.presentViewController(optionsMenu, animated: true, completion: nil)
            
        }
        
    }
    
    func selectPhotoFromCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func selectPhotoFromGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // image selected...
        shareRequest?.image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Post an image with a SLComposeServiceViewController
        let shareVC = ShareViewController.init(shareRequest: self.shareRequest!)
        shareVC.placeholder = self.placeholderText;
        shareVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext;
        
        shareVC.onDismissComplete = {
            () -> Void in
           self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        imagePicker.dismissViewControllerAnimated(true) { () -> Void in
            
            self.presentViewController(shareVC, animated: true) { () -> Void in
                // completion
            }

        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
