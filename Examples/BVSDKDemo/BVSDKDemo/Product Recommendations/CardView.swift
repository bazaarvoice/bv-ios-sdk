//
//  CardView.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class CardView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 0
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 0.5
    
  }
  
}
