//
//  OrderDetailViewController.swift
//  BVSDKDemo
//
//  Created by Cameron Ollivierre on 10/15/19.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class OrderDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let purchasedProducts: [BVTransactionItem]
    var productDict: [AnyHashable : Any]?


    public init(purchasedProducts: [BVTransactionItem]) {
        self.purchasedProducts = purchasedProducts
        super.init(nibName: ("OrderDetailViewController"), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      title = "Order"
      self.getProductInfo()
      tableView.estimatedRowHeight = 100
      tableView.rowHeight = 150
      tableView.tableFooterView = UIView(frame: CGRect.zero)
      
      let nibCartProductCell = UINib(nibName: "OrderHistoryProductTableViewCell", bundle: nil)
      tableView.register(nibCartProductCell, forCellReuseIdentifier: "OrderHistoryProductTableViewCell")
    }
    
    func getProductInfo() {
        var itemIds: [String] = []
        for products in purchasedProducts {
            
            itemIds.append(products.sku)
        }
        let initiateSubmitRequest = BVInitiateSubmitRequest(productIds: itemIds)
        initiateSubmitRequest.userToken = MockDataManager.sharedInstance.userToken
        initiateSubmitRequest.locale = "en_US"
        initiateSubmitRequest.submit({ (initiateSubmitResponseData) in
            let products = initiateSubmitResponseData.result?.products
            self.productDict = products
            
        }, failure: { (errors) in
            print(errors)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.purchasedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let productCell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryProductTableViewCell") as! OrderHistoryProductTableViewCell
      
      let product = self.purchasedProducts[indexPath.row]
      
      productCell.transaction = product
      
      return productCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //A valid userToken string must be set in the MockDataManager
      if (MockDataManager.sharedInstance.userToken != "REPLACE_ME") {
            let product = self.purchasedProducts[indexPath.row]
            let formData = productDict![product.sku] as? BVInitiateSubmitFormData
              
            let vc = WriteReviewViewController(nibName:"WriteReviewViewController", bundle: nil, reviewData: formData!)
            self.navigationController?.pushViewController(vc, animated: true)
            self.tableView.deselectRow(at: indexPath, animated: true)
      }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return false
    }
    
    
}
