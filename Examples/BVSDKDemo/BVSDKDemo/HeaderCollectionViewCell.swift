//
//  HeaderCollectionViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var textLbl: UILabel?
  override func awakeFromNib() {
    super.awakeFromNib()
    textLbl?.textColor = UIColor.bazaarvoiceNavy()
    textLbl?.baselineAdjustment = .alignCenters
  }
  
}
