//
//  CallToActionCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import FontAwesomeKit

class CallToActionCell: UITableViewCell {

    
    @IBOutlet weak var button : UIButton!
    @IBOutlet weak var rightIcon : UIImageView!
    @IBOutlet weak var leftIcon : UIImageView!
    
    
    func setCustomLeftIcon(icon : ((size: CGFloat) -> FAKFontAwesome!)) {
        leftIcon.image = getIconImage(icon)
    }
    
    func setCustomRightIcon(icon : ((size: CGFloat) -> FAKFontAwesome!)) {
        rightIcon.image = getIconImage(icon)
    }
    
    func getIconImage(icon : ((size: CGFloat) -> FAKFontAwesome!)) -> UIImage {
        
        let size = CGFloat(20)
        
        let newIcon = icon(size: size)
        newIcon.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        )
        
        return newIcon.imageWithSize(CGSize(width: size, height: size))
        
    }
    
}
