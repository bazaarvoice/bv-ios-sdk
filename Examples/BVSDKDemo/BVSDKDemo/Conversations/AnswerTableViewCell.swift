//
//  AnswerTableViewCell.swift
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


class AnswerTableViewCell: BVAnswerTableViewCell {
  
  @IBOutlet weak var writtenAtLabel : UILabel!
  @IBOutlet weak var authorNickname : UILabel!
  @IBOutlet weak var answerText : UILabel!
  @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
  
  var onAuthorNickNameTapped : ((_ authorId : String) -> Void)? = nil
  
  override var answer : BVAnswer? {
    didSet {
      if (answer?.userNickname != nil){
        self.authorNickname.linkAuthorNameLabel(fullText: answer!.userNickname!, author: answer!.userNickname!, target: self, selector: #selector(AnswerTableViewCell.tappedAuthor(_:)))
      } else {
        self.authorNickname.text = ""
      }
      answerText.text = answer!.answerText
      if let submissionTime = answer!.submissionTime{
        writtenAtLabel.text = dateTimeAgo(submissionTime)
      }
      else {
        writtenAtLabel.text = ""
      }
      
      if answer?.totalFeedbackCount?.int32Value > 0 {
        
        let totalFeedbackCountString = answer?.totalFeedbackCount?.stringValue ?? ""
        let totalPositiveFeedbackCountString = answer?.totalPositiveFeedbackCount?.stringValue ?? ""
        
        let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this answer helpful"
        
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
  
  
  func tappedAuthor(_ sender:UITapGestureRecognizer){
    if let onAuthorNameTapped = self.onAuthorNickNameTapped {
      onAuthorNameTapped((answer?.authorId)!)
    }
  }
  
  
}
