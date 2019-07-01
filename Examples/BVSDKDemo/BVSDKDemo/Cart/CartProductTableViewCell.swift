//
//  CartProductTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class CartProductTableViewCell: UITableViewCell {
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  
  var product : BVProduct? {
    
    didSet {
      if let _ = product {
        productTitle.text = product?.name
        productImageView.sd_setImage(with: NSURL(string: (product?.imageUrl!)!) as URL?)
        productPrice.text = "$0.00"
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
