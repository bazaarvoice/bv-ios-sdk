//
//  ProductDetailHeaderView.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import BVSDK

class ProductDetailHeaderView: UIView {
    
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var productStars : HCSStarRatingView!

    var product : BVProduct! {
        didSet {
            
            productImage.sd_setImageWithURL(NSURL(string: product.imageURL))
            productName.text = product.productName
            if (productStars != nil){
                productStars.value = CGFloat(product.averageRating)
            }
            
        }
    }
    
}
