//
//  BaseDemoComposeServiceViewController.swift
//  Curations Demo App
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import BVSDK

// This base class extends SLComposeServiceViewController, used for customizing photo posts to Curations.
// Both the in-app and extension demos in this app use this base class for customizing the post view controller UI.
class BaseDemoComposeServiceViewController: SLComposeServiceViewController {

    var postRequest : BVCurationsAddPostRequest?
    
    convenience init!(shareRequest:BVCurationsAddPostRequest) {
        
        self.init()
        self.postRequest = shareRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.configureCustomNaviBar()
        
        self.validateContent()
        
    }

    override func didSelectCancel() {
        super.dismiss(animated: true, completion: nil)
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        super.isContentValid()
        if (self.textView.text.characters.count > 0){
            return true
        }
        
        return false
    }
    
    override func loadPreviewView() -> UIView! {
        
        if (self.postRequest != nil && self.postRequest?.image != nil) {
            let resizedImage = self.imageWithImage((self.postRequest?.image)!, scaledToSize: CGSize(width: 80,height: 80))
            return UIImageView(image: resizedImage)
        } else {
            // No postRequest/image was provided so call the super as this class was likely loaded from an extension.
            return super.loadPreviewView()
        }
        
    }

    func configureCustomNaviBar() {
        
        self.navigationController?.navigationBar.tintColor = self.navibarTintColor()
        let navSize = self.navigationController?.navigationBar.frame.size
        self.navigationController?.navigationBar.setBackgroundImage(getTopWithColor(self.navibarBackgroundColor(), size: navSize!), for: .default)
        
    }
    

    func navibarBackgroundColor() -> UIColor {
        
        // bazaarvoice navy
        return UIColor(red: 0, green: 0.24, blue: 0.3, alpha: 1.0)
        
    }
    
    func navibarTintColor() -> UIColor {
        
        // white color
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    // Provide the logo for the navigation bar
    func getTopWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        if let img = UIImage(named: "icon_bvlogo") {
            // sizing here is a little vodoo...cough...hacky
            img.draw(in: CGRect(x: (size.width-size.height)/2, y: 0, width: size.height+20, height: size.height))
        }
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    // Resize a given image to newSize
    func imageWithImage(_ image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        if let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            return newImage
        } else {
            // wasn't able to get graphics context to scale image
            print("Error getting graphics context.")
            UIGraphicsEndImageContext()
            return image
        }
        
    }
}
