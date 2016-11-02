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

    var product : BVRecommendedProduct! {
        didSet {
            
            productImage.sd_setImage(with: URL(string: product.imageURL))
            productName.text = product.productName
            if (productStars != nil){
                productStars.value = CGFloat(product.averageRating)
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
