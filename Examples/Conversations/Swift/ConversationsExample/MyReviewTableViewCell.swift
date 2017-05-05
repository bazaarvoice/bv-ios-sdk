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
            
            var titleString = review?.title
            
            // Get the author and date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let dateString = dateFormatter.string(from: (review?.submissionTime)!)
            
            var badgesString = "\nBadges: ["
            
            // let's see if this author has any badges
            for badge : BVBadge in (review?.badges)! {
                
                badgesString += " \(badge.identifier!) "
                
            }
            
            badgesString += "]"
            
            titleString = titleString?.appending("\nBy \(review!.userNickname ?? "no author") on \(dateString)\(badgesString)")
            
            // Add any context data values, if present. E.g. Age, Gender, other....
            for contextDataValue in (review?.contextDataValues)! {
                titleString?.append("\n\(contextDataValue.dimensionLabel!): \(contextDataValue.valueLabel!)")
            }

            reviewTitle.text = titleString
            
            // Create a review body some example of data we can pull in.
            var reviewString = review?.reviewText
            
            reviewString?.append("\n")
            
            reviewString?.append("\nIs Recommended?  \(review!.isRecommended)")
            reviewString?.append("\nIs Syndicated?  \(review!.isSyndicated)")
            
            if (review!.isSyndicated && (review!.syndicationSource != nil)){
                reviewString?.append("\nSyndication Source: \(review!.syndicationSource!.name!)")
            }
            
            reviewString?.append("\nHelpful Count: \(review!.totalPositiveFeedbackCount!)")
            reviewString?.append("\nNot Helpful Count: \(review!.totalNegativeFeedbackCount!)")
            
            // See if there are context data values
            var secondaryRatingsText = "\nSecondary Ratings: ["
            
            // Check and see if this reviewer supplied any of the secondary ratings
            for rating : BVSecondaryRating in (review?.secondaryRatings)! {
                secondaryRatingsText += " \(rating.label!)(\(rating.value!)) "
            }
            
            secondaryRatingsText += "]"
            
            reviewString?.append(secondaryRatingsText)
            
            reviewText.text = reviewString
            
        }
    }
    
}
