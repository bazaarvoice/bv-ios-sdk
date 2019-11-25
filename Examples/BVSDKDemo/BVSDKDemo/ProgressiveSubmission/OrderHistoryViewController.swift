//
//  OrderHistoryViewController.swift
//  BVSDKDemo
//
//  Created by Cameron Ollivierre on 10/8/19.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class OrderHistoryViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      title = "Order History"
            
      tableView.estimatedRowHeight = 100
      tableView.rowHeight = 70
      tableView.tableFooterView = UIView(frame: CGRect.zero)
      
      let nibCartProductCell = UINib(nibName: "OrderHistoryTableViewCell", bundle: nil)
      tableView.register(nibCartProductCell, forCellReuseIdentifier: "OrderHistoryTableViewCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MockDataManager.sharedInstance.transactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let orderCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTableViewCell") as! OrderHistoryTableViewCell
      
      let transaction = MockDataManager.sharedInstance.transactionHistory[indexPath.row]
      
      orderCell.transaction = transaction
      
      return orderCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let transaction = MockDataManager.sharedInstance.transactionHistory[indexPath.row]
      let transactioItems = transaction.items
      let orderHistoryVC = OrderDetailViewController(purchasedProducts:transactioItems)
      self.navigationController?.pushViewController(orderHistoryVC, animated: true)
      self.tableView.deselectRow(at: indexPath, animated: true)
      
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return false
    }

}
