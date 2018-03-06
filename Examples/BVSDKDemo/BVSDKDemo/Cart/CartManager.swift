//
//  CartManager.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class CartManager {
  
  private var productsArray: [BVProduct] = []
  public var didPurchase = false
  
  private init() {} // Ensure only used as a singleton!
  
  static let sharedInstance : CartManager = {
    let instance = CartManager()
    return instance
  }()
  
  func addProduct(product: BVProduct) {
    productsArray.append(product)
  }
  
  func removeProduct(product: BVProduct) -> Bool {
    if let index = productsArray.index(of: product) {
      productsArray.remove(at: index)
      return true
    }
    
    return false
  }
  
  func productAtIndex(_ index: Int) -> BVProduct {
    return productsArray[index]
  }
  
  func numberOfItemsInCart() -> Int {
    return productsArray.count
  }
  
  func clearCart() {
    productsArray.removeAll(keepingCapacity: false)
  }
  
  func isProductInCart(product: BVProduct) -> Bool {
    return productsArray.contains(product)
  }
  
}
