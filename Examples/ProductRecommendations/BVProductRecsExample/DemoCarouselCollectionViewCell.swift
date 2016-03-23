//
//  DemoCarouselCollectionViewCell.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import HCSStarRatingView

class DemoCarouselCollectionViewCell: BVRecommendationCollectionViewCell {

    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var numReview : UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!
    
    override var bvProduct: BVProduct! {
        
        didSet {
            
            self.productName.text = bvProduct!.productName
            self.rating.text = "\(bvProduct!.averageRating ?? 0)"
            self.numReview.text = "(\(bvProduct!.numReviews ?? 0) reviews)"
            self.price.text = bvProduct!.price ?? ""
            self.starRating.value = CGFloat(bvProduct!.averageRating.floatValue)
            
            let imageUrl = NSURL(string: bvProduct!.imageURL)
            self.productImageView.sd_setImageWithURL(imageUrl)
            
        }
        
    }

}
