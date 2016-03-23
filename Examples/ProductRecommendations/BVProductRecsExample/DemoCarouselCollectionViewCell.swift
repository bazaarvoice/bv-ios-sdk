//
//  DemoCarouselCollectionViewCell.swift
//  BVProductRecsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class DemoCarouselCollectionViewCell: BVRecommendationCollectionViewCell {

    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var numReview : UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!

}
