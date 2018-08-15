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
      let author = review?.userNickname ?? "no author"
      
      // Get the author and date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
      
      var dateString: String = "N/A"
      if let submissionTime = review?.submissionTime {
        dateString = dateFormatter.string(from: submissionTime)
      }
      
      var badgesString = "\nBadges: ["
      
      // let's see if this author has any badges
      if let badges = review?.badges {
        badges.forEach { badgesString += " \($0.identifier!) " }
      }
      
      badgesString += "]"
      
      titleString = titleString?.appending("\nBy \(author) on \(dateString)\(badgesString)")
      
      // Add any context data values, if present. E.g. Age, Gender, other....
      
      if let contextDataValues = review?.contextDataValues {
        contextDataValues.forEach {
          let value = $0.valueLabel ?? "Value Not defined"
          let label = $0.dimensionLabel ?? "Label Not defined"
          titleString?.append("\n\(label): \(value)")
        }
      }
      
      reviewTitle.text = titleString
      
      // Create a review body some example of data we can pull in.
      var reviewString = review?.reviewText
      
      reviewString?.append("\n")
      
      reviewString?.append("\nIs Recommended?  \(review?.isRecommended ?? false)")
      reviewString?.append("\nIs Syndicated?  \(review?.isSyndicated ?? false)")
      
      if let isSyndicated = review?.isSyndicated,
        let syndicationSourceName = review?.syndicationSource?.name {
        if isSyndicated {
          reviewString?.append("\nSyndication Source: \(syndicationSourceName)")
        }
      }
      
      if let totalPositiveFeedbackCount = review?.totalPositiveFeedbackCount,
        let totalNegativeFeedbackCount = review?.totalNegativeFeedbackCount {
        reviewString?.append("\nHelpful Count: \(totalPositiveFeedbackCount)")
        reviewString?.append("\nNot Helpful Count: \(totalNegativeFeedbackCount)")
      }
      
      // See if there are context data values
      var secondaryRatingsText = "\nSecondary Ratings: ["
      
      // Check and see if this reviewer supplied any of the secondary ratings
      if let secondaryRatings = review?.secondaryRatings {
        secondaryRatings.forEach {
          let value = ($0.value as? NSInteger) ?? -1
          let label = $0.label ?? "Label Not defined"
          secondaryRatingsText += " \(label)(\(value)) "
        }
      }
      
      secondaryRatingsText += "]"
      
      reviewString?.append(secondaryRatingsText)
      
      // check for comments
      if let commentsCount = review?.comments.count {
        let commentsText = "\nNum Comments: [\(commentsCount)]"
        reviewString?.append(commentsText)
      }
      
      reviewText.text = reviewString
      
    }
  }
}
