//
//  OrderHistoryTableViewCell.swift
//  BVSDKDemo
//
//  Created by Cameron Ollivierre on 10/15/19.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class OrderHistoryTableViewCell: UITableViewCell {

      @IBOutlet weak var OrderIdLabel: UILabel!
      @IBOutlet weak var OrderDateLabel: UILabel!
      @IBOutlet weak var ItemCountLabel: UILabel!
      @IBOutlet weak var OrderTotalLabel: UILabel!

      
      var transaction : BVTransactionEvent? {
        
        didSet {
          if let _ = transaction {
            if let orderId = transaction?.orderId {
                OrderIdLabel.text = "Order ID: \(orderId)"
            }
            OrderDateLabel.text = "Friday, Oct 25th"
            if let itemCount = transaction?.items.count {
                itemCount == 1 ? (ItemCountLabel.text = "\(itemCount) item:") : (ItemCountLabel.text = "\(itemCount) items:")
            }
            if let orderTotal = transaction?.total {
                OrderTotalLabel.text = "$\(orderTotal)"
            }
            
          }
        }
      }
      
      override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
      }
      
    }
