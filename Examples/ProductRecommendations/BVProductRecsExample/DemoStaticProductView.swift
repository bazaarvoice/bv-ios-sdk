//
//  DemoStaticProductView.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import HCSStarRatingView

class DemoStaticProductView: BVProductRecommendationView {

    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var numReviews : UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!
    @IBOutlet weak var productReview : UILabel!
    @IBOutlet weak var author : UILabel!
    
    override var bvProduct : BVProduct! {
        
        didSet {
            
            self.productName?.text = bvProduct!.productName
            self.productImageView?.sd_setImageWithURL(NSURL(string: bvProduct!.imageURL))
            self.rating?.text = "\(bvProduct!.averageRating ?? 0)"
            self.numReviews?.text = "(\(bvProduct!.numReviews ?? 0) reviews)"
            self.starRating?.value = CGFloat(bvProduct!.averageRating ?? 0)
            
        }
        
    }
    
}
