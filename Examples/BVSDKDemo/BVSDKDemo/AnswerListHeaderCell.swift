//
//  AnswerListHeaderCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class AnswerListHeaderCell: UITableViewCell {
    
    @IBOutlet weak var questionTitle : UILabel!
    @IBOutlet weak var questionMetaData : UILabel!
    @IBOutlet weak var questionText : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var question : BVQuestion! {
        didSet {
            questionTitle.text = question.questionSummary
            questionText.text = question.questionDetails
            
            
            if let submissionTime = question.submissionTime, let nickname = question.userNickname {
                questionMetaData.text = dateTimeAgo(submissionTime) + " by " + nickname
            }
            else if let nickname = question.userNickname {
                questionMetaData.text = nickname
            }
            else if let submissionTime = question.submissionTime {
                questionMetaData.text = dateTimeAgo(submissionTime) + " by Anonymous"
            }
            else {
                questionMetaData.text = "Anonymous"
            }
            
            
        }
    }
    
}
