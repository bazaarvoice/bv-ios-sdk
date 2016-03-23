//
//  Util.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Util: NSObject {
    
    static func createSpinner() -> NVActivityIndicatorView {
        
        let spinner = NVActivityIndicatorView(frame: CGRectMake(0,0,40,40), type: NVActivityIndicatorType.BallScaleMultiple, color: UIColor.lightGrayColor(), size: CGSize(width: 40, height: 40))
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
    
}
