//
//  ReviewHighlightsDetailsTableViewCell.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 28/03/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ReviewHighlightsDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var view_Background: CardView!
    @IBOutlet weak var lbl_AuthorName: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_AuthorPlace: UILabel!
    @IBOutlet weak var txt_ReviewText: UILabel!
    
    var bVReviewHighligtsReview: BVReviewHighligtsReview = BVReviewHighligtsReview() {
        didSet {
            self.cellConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func cellConfiguration() {
        self.lbl_AuthorName.text = self.bVReviewHighligtsReview.reviewTitle
        self.lbl_time.text = self.bVReviewHighligtsReview.submissionTime
        self.lbl_AuthorPlace.text = self.bVReviewHighligtsReview.author
        self.txt_ReviewText.text = self.bVReviewHighligtsReview.reviewText
    }
    
}
