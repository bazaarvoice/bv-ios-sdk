//
//  DemoCell.swift
//  RecommendationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import BVSDK
import HCSStarRatingView
import SDWebImage

class DemoCell: BVRecommendationCollectionViewCell {
    
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var numReview : UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!
    
    override var bvProduct: BVProduct! {
        
        didSet {
            
            let imageUrl = NSURL(string: bvProduct.imageURL)
            self.productName.text = bvProduct.productName
            self.rating.text = "\(bvProduct.averageRating ?? 0)"
            self.numReview.text = "(\(bvProduct.numReviews ?? 0) reviews)"
            self.starRating.value = (CGFloat)(bvProduct.averageRating.floatValue)
            self.productImageView?.sd_setImageWithURL(imageUrl)
            
        }
        
    }
    
}