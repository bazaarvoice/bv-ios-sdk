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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.isBeingPresented){
            self.uploadPhoto()
        }
    }
    
    func uploadPhoto(){
        
        if Platform.isSimulator {
            
            self.selectPhotoFromGallery()
            
        } else {
            
            let optionsMenu = UIAlertController(title: nil, message: "Choose a photo source...", preferredStyle: .actionSheet)
            
            let closure = { (action: UIAlertAction!) -> Void in
                
                let index : Int = optionsMenu.actions.index(of: action)!
                
                switch index {
                    
                case 0:
                    self.selectPhotoFromCamera()
                    
                case 1:
                    self.selectPhotoFromGallery()
                    
                case 2:
                    self.presentingViewController?.dismiss(animated: true, completion: nil)

                default:
                    // ignored
                    break
                    
                }
                
            }
            
            optionsMenu.addAction(UIAlertAction(title: "Camera", style: .default, handler: closure))
            optionsMenu.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: closure))
            optionsMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: closure))
            
            self.present(optionsMenu, animated: true, completion: nil)
            
        }
        
    }
    
    func selectPhotoFromCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func selectPhotoFromGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // image selected...
        shareRequest?.image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Post an image with a SLComposeServiceViewController
        let shareVC = ShareViewController.init(shareRequest: self.shareRequest!)
        shareVC?.placeholder = self.placeholderText;
        shareVC?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        
        shareVC?.onDismissComplete = {
            () -> Void in
           self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        imagePicker.dismiss(animated: true) { () -> Void in
            
            self.present(shareVC!, animated: true) { () -> Void in
                // completion
            }

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    
}
