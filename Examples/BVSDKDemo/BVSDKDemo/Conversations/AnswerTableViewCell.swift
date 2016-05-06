//
//  AnswerTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var writtenAtLabel : UILabel!
    @IBOutlet weak var authorNickname : UILabel!
    @IBOutlet weak var answerText : UILabel!
    @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
    var answer : Answer? {
        didSet {
            authorNickname.text = answer!.userNickname
            answerText.text = answer!.answerText
            if let submissionTime = answer!.submissionTime{
                writtenAtLabel.text = dateTimeAgo(submissionTime)
            }
            else {
                writtenAtLabel.text = ""
            }
            
            if (answer?.totalFeedbackCount > 0){
                
                let totalFeedbackCountString = String(answer!.totalFeedbackCount)
                let totalPositiveFeedbackCountString = String(answer!.totalPositiveFeedbackCount)
                
                let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this answer helpful"
                
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
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
