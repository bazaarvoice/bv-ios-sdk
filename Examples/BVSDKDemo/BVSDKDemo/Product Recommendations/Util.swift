//
//  Util.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Util: NSObject {
    
    static func createSpinner() -> NVActivityIndicatorView {
        
        let spinner = NVActivityIndicatorView(frame: CGRectMake(0,0,40,40), type: .BallScaleMultiple, color: .lightGrayColor(), padding: 40)
        spinner.startAnimation()
        return spinner
        
    }
    
    static func createSpinner(color : UIColor, size: CGSize, padding: CGFloat) -> NVActivityIndicatorView {
        
        let spinner = NVActivityIndicatorView(frame: CGRectMake(0,0,size.width,size.height), type: .BallScaleMultiple, color: color, padding: padding)
        spinner.startAnimation()
        return spinner
        
    }

    static func createErrorLabel() -> UILabel {
        
        let errorLabel = UILabel()
        errorLabel.text = "An Error Occurred"
        errorLabel.textAlignment = .Center
        errorLabel.textColor = UIColor.lightGrayColor()
        errorLabel.numberOfLines = 1
        return errorLabel
        
    }
    
}

extension UIColor {
    
    static func bazaarvoiceNavy() -> UIColor {
        return UIColor(red: 0, green: 0.24, blue: 0.3, alpha: 1.0)
    }
    
    static func bazaarvoiceTeal() -> UIColor {
        return UIColor(red: 0, green: 0.67, blue: 0.56, alpha: 1.0)
    }
    
    static func bazaarvoiceGold() -> UIColor {
        return UIColor(red: 0.99, green: 0.72, blue: 0.07, alpha: 1.0)
    }
    
    static func appBackground() -> UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    }
    
}


extension UIImageView {
    
    /*!
    Fade in an imageView with a placeholder image, if the image is not cached.
    */
    public func sd_setImageWithURLWithFade(url: NSURL!, placeholderImage placeholder: UIImage!)
    {
        
        self.sd_setImageWithURL(url, placeholderImage: placeholder) { (image, error, cacheType, url) -> Void in
        
            if cacheType == .None
            {
                self.alpha = 0
                UIView.transitionWithView(self, duration: 0.6, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.image = image
                    self.alpha = 1
                    }, completion: nil)
                
            }
        }
    }
}

// Utility to check if a partcilar ViewController wants to support different orientations than the default build.
extension UINavigationController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.visibleViewController!.supportedInterfaceOrientations()
    }
    
    public override func shouldAutorotate() -> Bool {
        if ((visibleViewController) != nil){
            return self.visibleViewController!.shouldAutorotate()
        } else {
            return false
        }
    }
}

// Workaround for bug: http://www.openradar.me/22385765
extension UIAlertController {
    public override func shouldAutorotate() -> Bool {
        return true
    }
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
}

// Test if current Platform is simulator or not
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()

    
    
    static func createSpinner() -> NVActivityIndicatorView {
        
        let spinner = NVActivityIndicatorView(frame: CGRectMake(0,0,40,40), type: .BallScaleMultiple, color: .lightGrayColor(), padding: 40)
        spinner.startAnimation()
        return spinner
        
    }
    
    static func createSpinner(color : UIColor, size: CGSize, padding: CGFloat) -> NVActivityIndicatorView {
        
        let spinner = NVActivityIndicatorView(frame: CGRectMake(0,0,size.width,size.height), type: .BallScaleMultiple, color: color, padding: padding)
        spinner.startAnimation()
        return spinner
        
    }
    
    static func createErrorLabel() -> UILabel {
        
        let errorLabel = UILabel()
        errorLabel.text = "An Error Occurred"
        errorLabel.textAlignment = .Center
        errorLabel.textColor = UIColor.lightGrayColor()
        errorLabel.numberOfLines = 1
        return errorLabel
        
    }
    
}






