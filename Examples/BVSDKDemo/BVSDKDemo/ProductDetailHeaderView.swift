//
//  ProductDetailHeaderView.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import BVSDK

/**
 If the header in your this detail view is a BVRecommended, set the product variable.
 If the header in your detail view is a BVStore, set the store variable
 */
class ProductDetailHeaderView: UIView {
  
  @IBOutlet weak var productImage : UIImageView!
  @IBOutlet weak var productName : UILabel!
  @IBOutlet weak var productStars : HCSStarRatingView!
  
  var product : BVProduct? {
    didSet {
      if let url = product?.imageUrl {
        productImage.sd_setImage(with: NSURL(string: url) as? URL)
      }
      productName.text = product?.name
      
      if (productStars != nil){
        if let rating = product?.averageRating {
          productStars.value = CGFloat(rating)
        }else {
          productStars.value = 0.0
        }
      }
      
    }
  }
  
  var store : BVStore! {
    didSet {
      
      if store.imageUrl != nil {
        productImage.sd_setImage(with: URL(string: store.imageUrl!))
      }
      
      if (store.name != nil){
        productName.text = store.name
      }
      
      if (productStars != nil && store.reviewStatistics?.averageOverallRating != nil){
        productStars.value = CGFloat((store.reviewStatistics?.averageOverallRating)!)
      } else if productStars != nil {
        productStars.value = 0
      }
      
    }
  }
  
}
