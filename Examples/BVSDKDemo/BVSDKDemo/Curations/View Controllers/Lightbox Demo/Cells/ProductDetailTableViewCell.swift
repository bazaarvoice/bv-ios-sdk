//
//  ProductDetailTableViewCell.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import HCSStarRatingView

class ProductDetailTableViewCell: UITableViewCell {
  
  @IBOutlet weak var ratingStars: HCSStarRatingView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var productImageView: UIImageView!
  
  @IBOutlet weak var productNameLabel: UILabel!
  
  @IBOutlet weak var shopNowButton: UIButton!
  
  var product : BVCurationsProductDetail? {
    
    didSet {
      
      self.productNameLabel.text = product!.productName
      let productImageUrl : URL = URL(string:self.product!.productImageUrl)!
      self.productImageView?.sd_setImageWithURLWithFade(productImageUrl, placeholderImage: UIImage(named: ""))
      
      self.shopNowButton.layer.borderColor = UIColor.darkGray.cgColor
      self.shopNowButton.layer.borderWidth = 1
      
      let nf = NumberFormatter()
      nf.numberStyle = .decimal
      let ratingAvg = nf.string(from: (product?.avgRating)!)
      
      self.ratingStars.value = CGFloat((product?.avgRating)!)
      
      let numReviews = (product?.totalReviewCount.stringValue)!
      
      let ratingFromat = String(format: "%.1f", Double(ratingAvg!)!)
      
      self.ratingLabel.text =  ratingFromat + " (" + numReviews + " reviews)"
      
    }
  }
  
  
  @IBAction func shopNowTapped(_ sender: AnyObject) {
    
    if let onShopNowButtonTapped = self.onShopNowButtonTapped {
      onShopNowButtonTapped(product!)
    }
  }
  
  
  var onShopNowButtonTapped : ((_ product : BVCurationsProductDetail) -> Void)? = nil
  
}
