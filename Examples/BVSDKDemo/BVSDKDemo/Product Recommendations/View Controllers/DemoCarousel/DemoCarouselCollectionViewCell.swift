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
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!
    
    override var bvRecommendedProduct: BVRecommendedProduct! {
        
        didSet {
            
            self.productName.text = bvRecommendedProduct!.productName
            self.price.text = bvRecommendedProduct!.price 
            self.starRating.value = CGFloat(bvRecommendedProduct!.averageRating.floatValue)
            
            let imageUrl = URL(string: bvRecommendedProduct!.imageURL)
            self.productImageView.sd_setImage(with: imageUrl)
            
        }
        
    }

}
