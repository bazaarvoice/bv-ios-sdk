//
//  NewProductTableViewCell.swift
//  BVSDKDemo
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RatingTableViewCell: UITableViewCell {
    
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
    
    var review : Review? {
        
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
            reviewStars.value = CGFloat(review!.rating!)
            if (review!.thumbNailImageUrl != nil) {
                reviewPhoto.sd_setImageWithURL(NSURL(string: review!.thumbNailImageUrl!))
            }
            else {
                reviewPhoto.image = nil
            }
            
            if let submissionTime = review!.submissionTime, let nickname = review!.author?.userNickname {
                reviewAuthor.text = dateTimeAgo(submissionTime) + " by " + nickname
            }
            else if let nickname = review!.author?.userNickname {
                reviewAuthor.text = nickname
            }
            else if let submissionTime = review!.submissionTime {
                reviewAuthor.text = dateTimeAgo(submissionTime) + " by Anonymous"
            }
            else {
                reviewAuthor.text = "Anonymous"
            }
            
            if let authorLocation = review!.userLocation {
                reviewAuthorLocation.text = authorLocation
            }
            else {
                reviewAuthorLocation.text = ""
            }
            
            if (review?.totalFeedbackCount > 0){
                
                let totalFeedbackCountString = String(review!.totalFeedbackCount)
                let totalPositiveFeedbackCountString = String(review!.totalPositiveFeedbackCount)
                
                 let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this review helpful"
                
                let attributedString = NSMutableAttributedString(string: helpfulText as String, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12.0)])

                let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(12.0)]
                let colorFontAttribute = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
                
                // Part of string to be bold
                attributedString.addAttributes(boldFontAttribute, range: (helpfulText as NSString).rangeOfString(totalFeedbackCountString))
                attributedString.addAttributes(boldFontAttribute, range: (helpfulText as NSString).rangeOfString(totalPositiveFeedbackCountString))

                // Make text black
                attributedString.addAttributes(colorFontAttribute , range: (helpfulText as NSString).rangeOfString(totalFeedbackCountString, options: .BackwardsSearch))
                 attributedString.addAttributes(colorFontAttribute , range: (helpfulText as NSString).rangeOfString(totalPositiveFeedbackCountString))
               
                usersFoundHelpfulLabel.attributedText = attributedString
                
            } else {
                usersFoundHelpfulLabel.text = ""
            }
            
            self.setNeedsLayout()
            
        }
        
    }
    
}
