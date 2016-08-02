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
    
    override var bvRecommendedProduct: BVRecommendedProduct! {
        
        didSet {
            
            let imageUrl = NSURL(string: bvRecommendedProduct.imageURL)
            self.productName.text = bvRecommendedProduct.productName
            self.rating.text = "\(bvRecommendedProduct.averageRating ?? 0)"
            self.numReview.text = "(\(bvRecommendedProduct.numReviews ?? 0) reviews)"
            self.starRating.value = (CGFloat)(bvRecommendedProduct.averageRating.floatValue)
            self.productImageView?.sd_setImageWithURL(imageUrl)
            
        }
        
    }
    
}