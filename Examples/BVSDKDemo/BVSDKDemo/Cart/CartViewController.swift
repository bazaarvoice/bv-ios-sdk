//
//  CartViewController.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//


import UIKit
import BVSDK

class CartViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyView: UIView!
  @IBOutlet weak var checkoutButton: UIButton!
  
  /// NumberFormatter to get the price of a product formatted right
  lazy var productPriceFormatter: NumberFormatter = {
    let productPriceFormatter = NumberFormatter()
    productPriceFormatter.numberStyle = .currency
    productPriceFormatter.locale = NSLocale.current
    return productPriceFormatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Cart"
    
    self.styleCheckoutButtonButton()
    
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    
    let nibCartProductCell = UINib(nibName: "CartProductTableViewCell", bundle: nil)
    tableView.register(nibCartProductCell, forCellReuseIdentifier: "CartProductTableViewCell")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    checkEmptyStateOfCart()
    tableView.reloadData()
  }
  
  private func styleCheckoutButtonButton(){
    self.checkoutButton.layer.cornerRadius = 4
    self.checkoutButton.layer.backgroundColor = UIColor.bazaarvoiceNavy().cgColor
    self.checkoutButton.setTitleColor(UIColor.white, for: .normal)
  }
  
  @IBAction func clearAllButtonPressed() {
    let alertView = UIAlertController(title: "Clear all?", message: "Do you really want to clear all items from your cart?", preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
    alertView.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (alertAction) -> Void in
      self.clearCart()
    }))
    present(alertView, animated: true, completion: nil)
  }
  
  
  @IBAction func checkoutButtonPressed(_ sender: AnyObject) {
    
    // Fire BVPixel
    
    CartManager.sharedInstance.didPurchase = true
    
    var transactionItems = [BVTransactionItem]()
    // will be used to provide a mock reponse for BVPINRequest.getPendingPins
    var products = [BVProduct]()
    for index in 0 ..< CartManager.sharedInstance.numberOfItemsInCart() {
      
      let product = CartManager.sharedInstance.productAtIndex(index)
      products.append(product)
      
      let currTransaction = BVTransactionItem(sku:product.identifier,
                                              name: product.name,
                                              category: product.categoryId,
                                              price: 0.01,
                                              quantity: 1,
                                              imageUrl: product.imageUrl)
      
      
      transactionItems.append(currTransaction)
    }
    
    /*
     Construct a BVTransaction
     OrderId, orderTotal, and orderItems are required.
     You may include any other key value params you'd like.
     BVTransaction also has convenience setters for commonly used params.
     */
    
    let transaction = BVTransactionEvent(orderId:"123456",
                                         orderTotal: 0.00,
                                         orderItems: transactionItems,
                                         andOtherParams: ["state":"TX","email":"some.one@domain.com"])
    
    transaction.shipping = 0.00
    transaction.tax = 0.00
    
    // Use the BVPixel to track the Conversion Transaction Event.
    BVPixel.trackEvent(transaction)
    
    //BVAnalyticsManager.shared().flushQueue() // Send the event immediately (just for demo purposes)
    
    // Clear out the cart and let user know the demo transaction was complete.
    
    clearCart()
    
    createMockPins(products)
    
    _ = SweetAlert().showAlert("Success!", subTitle: "Thank you for your order!", style: .success)
    _ = self.navigationController?.popViewController(animated: true)
    
  }
  
  
  func clearCart() {
    CartManager.sharedInstance.clearCart()
    tableView.reloadData()
    
    setEmptyViewVisible(visible: true)
  }
  
  private func createMockPins(_ products: [BVProduct]) {
    MockDataManager.sharedInstance.generateMockPinReponse(fromProducts: products)
  }
  
  func setEmptyViewVisible(visible: Bool) {
    emptyView.isHidden = !visible
    if visible {
      //clearButton.isEnabled = false
        self.view.bringSubviewToFront(emptyView)
    } else {
      //clearButton.isEnabled = true
        self.view.sendSubviewToBack(emptyView)
    }
  }
  
  func checkEmptyStateOfCart() {
    setEmptyViewVisible(visible: CartManager.sharedInstance.numberOfItemsInCart() == 0)
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CartManager.sharedInstance.numberOfItemsInCart()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let productCell = tableView.dequeueReusableCell(withIdentifier: "CartProductTableViewCell") as! CartProductTableViewCell
    
    let product = CartManager.sharedInstance.productAtIndex(indexPath.row)
    
    productCell.product = product
    
    return productCell
  }
  
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      let product = CartManager.sharedInstance.productAtIndex(indexPath.row)
      let successful = CartManager.sharedInstance.removeProduct(product: product)
      
      if successful == true {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath as IndexPath], with: .right)
        tableView.endUpdates()
      }
      
      checkEmptyStateOfCart()
    }
  }
  
}
