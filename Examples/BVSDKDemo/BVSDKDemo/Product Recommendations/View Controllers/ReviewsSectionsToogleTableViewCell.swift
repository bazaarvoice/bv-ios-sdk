//
//  ReviewsSectionsToogleTableViewCell.swift
//  BVSDKDemo
//
//  Created by Rahul on 29/10/25.
//  Copyright © 2025 Bazaarvoice. All rights reserved.
//

import UIKit
import QuartzCore
import FontAwesomeKit

class ReviewsSectionsToogleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var button : UIButton!
    @IBOutlet weak var rightIcon : UIImageView!
    @IBOutlet weak var leftIcon : UIImageView!
    @IBOutlet weak var toggleReviewHighlightsButton: UIButton!
      
    func setCustomLeftIcon(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?)) {
      leftIcon.image = getIconImage(icon)
    }
    
    func setCustomRightIcon(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?)) {
      rightIcon.image = getIconImage(icon)
    }
      
      func setReviewHighlightsButtonTitle(isOn: Bool) {
          toggleReviewHighlightsButton.setTitle(isOn ? "Hide Review Highlights" : "Show Review Highlights", for: .normal)
          toggleReviewHighlightsButton.setImage(UIImage(systemName: isOn ? "arrowtriangle.up" : "arrowtriangle.down"), for: .normal)
      }
    
    func getIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?)) -> UIImage {
      
      let size = CGFloat(20)
      
      let newIcon = icon(size)
      newIcon?.addAttribute(
          NSAttributedString.Key.foregroundColor.rawValue,
        value: UIColor.lightGray.withAlphaComponent(0.5)
      )
      
      return newIcon!.image(with: CGSize(width: size, height: size))
      
    }
    
  }
