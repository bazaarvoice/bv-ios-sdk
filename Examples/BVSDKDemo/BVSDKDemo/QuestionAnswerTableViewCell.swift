//
//  QuestionAnswerTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
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


class QuestionAnswerTableViewCell: BVQuestionTableViewCell {
    
    @IBOutlet weak var questionTitle : UILabel!
    @IBOutlet weak var questionMetaData : UILabel!
    @IBOutlet weak var questionBody : UILabel!
    @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
    
    var onAuthorNickNameTapped : ((_ authorId : String) -> Void)? = nil
    
    override var question : BVQuestion? {
        
        didSet {
            
            questionTitle.text = question?.questionSummary
            questionBody.text  = question?.questionDetails
            
            if (question?.userNickname != nil){
                self.linkAuthorNameLabel(fullText: "Asked by " + (question?.userNickname)!, author: (question?.userNickname)!)
            } else {
                questionMetaData.text = ""
            }
            
            
            if question?.totalFeedbackCount?.int32Value > 0 {
                
                let totalFeedbackCountString = question?.totalFeedbackCount?.stringValue ?? ""
                let totalPositiveFeedbackCountString = question?.totalPositiveFeedbackCount?.stringValue ?? ""
                
                let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this question helpful"
                
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
            
        }
        
    }
    
    func linkAuthorNameLabel(fullText : String, author : String) {
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.setAttributes([:], range: NSRange(0..<attributedString.length)) // remove all the default attributes
        
        let colorFontAttribute = [NSForegroundColorAttributeName: UIColor.blue]
        
        attributedString.addAttributes(colorFontAttribute , range: (fullText as NSString).range(of: author, options: .backwards))
        
        self.questionMetaData.attributedText = attributedString
        self.questionMetaData.isUserInteractionEnabled = true
        
        // Here the full label will be tappable. If you wanted to make just a part of the label
        // tappable you'd need to check the frame when tapped, or use a different label.
        let tapAuthorGesture = UITapGestureRecognizer(target: self, action: #selector(RatingTableViewCell.tappedAuthor(_:)))
        self.questionMetaData.addGestureRecognizer(tapAuthorGesture)
    }
    
    func tappedAuthor(_ sender:UITapGestureRecognizer){
        if let onAuthorNameTapped = self.onAuthorNickNameTapped {
            onAuthorNameTapped((question?.authorId)!)
        }
    }

}
