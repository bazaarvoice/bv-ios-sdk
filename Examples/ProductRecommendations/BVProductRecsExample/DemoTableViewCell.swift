//
//  DemoTableViewCell.swift
//  BVProductRecsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class DemoTableViewCell: BVRecommendationTableViewCell {
    
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var numReview : UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!
    @IBOutlet weak var productReview : UILabel!
    @IBOutlet weak var author : UILabel!
    
}
