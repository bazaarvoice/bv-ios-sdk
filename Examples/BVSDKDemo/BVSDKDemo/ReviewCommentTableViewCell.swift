//
//  ReviewCommentTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class ReviewCommentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var writtenAtLabel : UILabel!
  @IBOutlet weak var authorNickname : UILabel!
  @IBOutlet weak var commentText : UILabel!
  @IBOutlet weak var usersFoundHelpfulLabel: UILabel!
  
  var onAuthorNickNameTapped : ((_ authorId : String) -> Void)? = nil
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  var comment : BVComment? {
    didSet {
      
      if let nick = comment?.userNickname {
        self.authorNickname.linkAuthorNameLabel(fullText: nick, author: nick, target:self, selector: #selector(RatingTableViewCell.tappedAuthor(_:)))
      } else {
        self.authorNickname.text = ""
      }
      commentText.text = comment!.commentText
      if let submissionTime = comment!.submissionTime{
        writtenAtLabel.text = dateTimeAgo(submissionTime)
      }
      else {
        writtenAtLabel.text = ""
      }
      
      if (comment?.totalFeedbackCount?.int32Value)! > 0 {
        
        let totalFeedbackCountString = comment?.totalFeedbackCount?.stringValue ?? ""
        let totalPositiveFeedbackCountString = comment?.totalPositiveFeedbackCount?.stringValue ?? ""
        
        let helpfulText = totalPositiveFeedbackCountString + " of " + totalFeedbackCountString +  " users found this comment helpful"
        
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
      onAuthorNameTapped((comment?.authorId)!)
    }
  }
  
}
