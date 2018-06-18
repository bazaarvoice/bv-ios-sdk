//
//  Util.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FontAwesomeKit

class Util: NSObject {
  
  static func createSpinner() -> NVActivityIndicatorView {
    
    let spinner = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 40,height: 40), type: .ballScaleMultiple, color: .lightGray, padding: 40)
    spinner.startAnimating()
    return spinner
    
  }
  
  static func createSpinner(_ color : UIColor, size: CGSize, padding: CGFloat) -> NVActivityIndicatorView {
    
    let spinner = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height), type: .ballScaleMultiple, color: color, padding: padding)
    spinner.startAnimating()
    return spinner
    
  }
  
  static func createErrorLabel() -> UILabel {
    
    let errorLabel = UILabel()
    errorLabel.text = "An Error Occurred"
    errorLabel.textAlignment = .center
    errorLabel.textColor = UIColor.lightGray
    errorLabel.numberOfLines = 1
    return errorLabel
    
  }
  
  /// Get a default light grey icon
  static func getFontAwesomeIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?)) -> UIImage {
    
    return self.getFontAwesomeIconImage(icon, color: UIColor.lightGray, alpha: 0.5, size: 20)
    
  }
  
  /// Get an icon with specified size, color, and alpha
  static func getFontAwesomeIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?),
                                      color : UIColor,
                                      alpha : CGFloat,
                                      size : CGFloat) -> UIImage {
    
    let newIcon = icon(size)
    newIcon?.addAttribute(
      NSForegroundColorAttributeName,
      value: color.withAlphaComponent(alpha)
    )
    
    return newIcon!.image(with: CGSize(width: size, height: size))
    
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
  public func sd_setImageWithURLWithFade(_ url: URL!, placeholderImage placeholder: UIImage!)
  {
    
    self.sd_setImage(with: url, placeholderImage: placeholder, options: []) { (image, error, cacheType, url) in
      if cacheType == .none
      {
        self.alpha = 0
        UIView.transition(with: self, duration: 0.6, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
          self.image = image
          self.alpha = 1
        }, completion: nil)
        
      }
    }
    
  }
}

// Utility to check if a partcilar ViewController wants to support different orientations than the default build.
extension UINavigationController {
  open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    if let visible = visibleViewController {
      return visible.supportedInterfaceOrientations
    }
    
    return .portrait
  }
  
  open override var shouldAutorotate : Bool {
    if ((visibleViewController) != nil){
      return self.visibleViewController!.shouldAutorotate
    } else {
      return false
    }
  }
}

// Workaround for bug: http://www.openradar.me/22385765
extension UIAlertController {
  open override var shouldAutorotate : Bool {
    return true
  }
  open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.all
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
    
    let spinner = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 40,height: 40), type: .ballScaleMultiple, color: .lightGray, padding: 40)
    spinner.startAnimating()
    return spinner
    
  }
  
  static func createSpinner(_ color : UIColor, size: CGSize, padding: CGFloat) -> NVActivityIndicatorView {
    
    let spinner = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height), type: .ballScaleMultiple, color: color, padding: padding)
    spinner.startAnimating()
    return spinner
    
  }
  
  static func createErrorLabel() -> UILabel {
    
    let errorLabel = UILabel()
    errorLabel.text = "An Error Occurred"
    errorLabel.textAlignment = .center
    errorLabel.textColor = UIColor.lightGray
    errorLabel.numberOfLines = 1
    return errorLabel
    
  }
  
}

extension UILabel {
  
  func linkAuthorNameLabel(fullText : String, author : String, target: Any?, selector : Selector?) {
    
    let attributedString = NSMutableAttributedString(string: fullText)
    attributedString.setAttributes([:], range: NSRange(0..<attributedString.length)) // remove all the default attributes
    
    let colorFontAttribute = [NSForegroundColorAttributeName: UIColor.blue]
    
    attributedString.addAttributes(colorFontAttribute , range: (fullText as NSString).range(of: author, options: .backwards))
    
    self.attributedText = attributedString
    self.isUserInteractionEnabled = true
    
    // Here the full label will be tappable. If you wanted to make just a part of the label
    // tappable you'd need to check the frame when tapped, or use a different label.
    let tapLabelGesture = UITapGestureRecognizer(target: target, action: selector)
    self.addGestureRecognizer(tapLabelGesture)
    
  }
  
  
}

