//
//  OrderHistoryProductTableViewCell.swift
//  BVSDKDemo
//
//  Created by Cameron Ollivierre on 10/21/19.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class OrderHistoryProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!

    var transaction : BVTransactionItem? {
      
      didSet {
        if let _ = transaction {
          if let title = transaction?.name {
              productTitle.text = "Title: \(title)"
          }
          productImageView.sd_setImage(with: NSURL(string: (transaction?.imageUrl!)!) as URL?)
          if let price = transaction?.price {
              productPrice.text = "$\(price)"
          }
        }
      }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
