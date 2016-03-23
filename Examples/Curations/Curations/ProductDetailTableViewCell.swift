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
            let productImageUrl : NSURL = NSURL(string:self.product!.productImageUrl)!
            self.productImageView?.sd_setImageWithURLWithFade(productImageUrl, placeholderImage: UIImage(named: ""))
            
            self.shopNowButton.layer.borderColor = UIColor.darkGrayColor().CGColor
            self.shopNowButton.layer.borderWidth = 1
            
            let nf = NSNumberFormatter()
            nf.numberStyle = .DecimalStyle
            let ratingAvg = nf.stringFromNumber((product?.avgRating)!)
            
            self.ratingStars.value = CGFloat((product?.avgRating)!)
            
            let numReviews = (product?.totalReviewCount.stringValue)!
            
            let ratingFromat = String(format: "%.1f", Double(ratingAvg!)!)
            
            self.ratingLabel.text =  ratingFromat + " (" + numReviews + " reviews)"
            
        }
    }
    
    
    @IBAction func shopNowTapped(sender: AnyObject) {
        
        if let onShopNowButtonTapped = self.onShopNowButtonTapped {
            onShopNowButtonTapped(product: product!)
        }
    }
    
    
    var onShopNowButtonTapped : ((product : BVCurationsProductDetail) -> Void)? = nil
    
}
