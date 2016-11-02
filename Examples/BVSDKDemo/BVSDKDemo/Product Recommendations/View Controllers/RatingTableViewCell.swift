//
//  NewProductTableViewCell.swift
//  BVSDKDemo
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import BVSDK
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class RatingTableViewCell: BVReviewTableViewCell {
    
    @IBOutlet weak var reviewText : UILabel!
    @IBOutlet weak var reviewTitle : UILabel!
    @IBOutlet weak var reviewAuthor : UILabel!
    @IBOutlet weak var reviewAuthorLocation : UILabel!
    @IBOutlet weak var reviewStars : HCSStarRatingView!
    @IBOutlet weak var reviewPhoto : UIImageView!
    @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var review : BVReview? {
        
        didSet {
            
            // set the review text, while increasing line spacing
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            
            let attrString = NSMutableAttributedString(string: review!.reviewText ?? "")
            attrString.addAttribute(
                NSParagraphStyleAttributeName,
                value: paragraphStyle,
                range: NSMakeRange(0, attrString.length)
            )
            
            reviewText.attributedText = attrString
            
            
            reviewTitle.text = review!.title
            reviewStars.value = CGFloat(review!.rating)
            if let photoUrl = review?.photos.first?.sizes?.normalUrl {
                reviewPhoto.sd_setImage(with: URL(string: photoUrl))
            }
            else {
                reviewPhoto.image = nil
            }
            
            if let submissionTime = review?.submissionTime, let nickname = review?.userNickname {
                reviewAuthor.text = dateTimeAgo(submissionTime) + " by " + nickname
            }
            else if let nickname = review?.userNickname {
                reviewAuthor.text = nickname
            }
            else if let submissionTime = review?.submissionTime {
                reviewAuthor.text = dateTimeAgo(submissionTime) + " by Anonymous"
            }
            else {
                reviewAuthor.text = "Anonymous"
            }
            
            if let authorLocation = review?.userLocation {
                reviewAuthorLocation.text = authorLocation
            }
            else {
                reviewAuthorLocation.text = ""
            }
            
            if review?.totalFeedbackCount?.int32Value > 0 {
                                
                let totalFeedbackCountString = review?.totalFeedbackCount?.stringValue ?? ""
                let totalPositiveFeedbackCountString = review?.totalPositiveFeedbackCount?.stringValue ?? ""
                
                 let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this review helpful"
                
                let attributedString = NSMutableAttributedString(string: helpfulText as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12.0)])

                let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
                let colorFontAttribute = [NSForegroundColorAttributeName: UIColor.darkGray]
                
                // Part of string to be bold
                attributedString.addAttributes(boldFontAttribute, range: (helpfulText as NSString).range(of: totalFeedbackCountString))
                attributedString.addAttributes(boldFontAttribute, range: (helpfulText as NSString).range(of: totalPositiveFeedbackCountString))

                // Make text black
                attributedString.addAttributes(colorFontAttribute , range: (helpfulText as NSString).range(of: totalFeedbackCountString, options: .backwards))
                 attributedString.addAttributes(colorFontAttribute , range: (helpfulText as NSString).range(of: totalPositiveFeedbackCountString))
               
                usersFoundHelpfulLabel.attributedText = attributedString
                
            } else {
                usersFoundHelpfulLabel.text = ""
            }
            
            self.setNeedsLayout()
            
        }
        
    }
    
}
