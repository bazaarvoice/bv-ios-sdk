//
//  DemoStaticProductView.swift
//  BVProductRecsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class DemoStaticProductView: BVProductRecommendationView {

    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var numReviews : UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!
    @IBOutlet weak var productReview : UILabel!
    @IBOutlet weak var author : UILabel!
    
}
