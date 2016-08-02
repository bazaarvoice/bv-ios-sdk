//
//  QuestionAnswerTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class QuestionAnswerTableViewCell: BVQuestionTableViewCell {
    
    @IBOutlet weak var questionTitle : UILabel!
    @IBOutlet weak var questionMetaData : UILabel!
    @IBOutlet weak var questionBody : UILabel!
    @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
    
    override var question : BVQuestion? {
        
        didSet {
            
            questionTitle.text = question?.questionSummary
            questionBody.text  = question?.questionDetails
            questionMetaData.text = question?.userNickname
            
            if question?.totalFeedbackCount?.intValue > 0 {
                
                let totalFeedbackCountString = question?.totalFeedbackCount?.stringValue ?? ""
                let totalPositiveFeedbackCountString = question?.totalPositiveFeedbackCount?.stringValue ?? ""
                
                let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this question helpful"
                
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

}
