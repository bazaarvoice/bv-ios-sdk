//
//  NewProductPageConversationsViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import QuartzCore
import FontAwesomeKit

class ProductPageButtonCell: UITableViewCell {
  
  
  @IBOutlet weak var button : UIButton!
  @IBOutlet weak var rightIcon : UIImageView!
  @IBOutlet weak var leftIcon : UIImageView!
  
  
  func setCustomLeftIcon(_ icon : ((_ size: CGFloat) -> FAKFontAwesome!)) {
    leftIcon.image = getIconImage(icon)
  }
  
  func setCustomRightIcon(_ icon : ((_ size: CGFloat) -> FAKFontAwesome!)) {
    rightIcon.image = getIconImage(icon)
  }
  
  func getIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome!)) -> UIImage {
    
    let size = CGFloat(20)
    
    let newIcon = icon(size)
    newIcon?.addAttribute(
      NSForegroundColorAttributeName,
      value: UIColor.lightGray.withAlphaComponent(0.5)
    )
    
    return newIcon!.image(with: CGSize(width: size, height: size))
    
  }
  
}
