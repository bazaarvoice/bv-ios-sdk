//
//  MyReviewTableViewCell.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class MyReviewTableViewCell: BVReviewTableViewCell {
    @IBOutlet weak var reviewTitle : UILabel!
    @IBOutlet weak var reviewText : UILabel!

    override var review: BVReview? {
        didSet {
            reviewTitle.text = review?.title
            reviewText.text = review?.reviewText
        }
    }
    
}
