//
//  MyQuestionTableViewCell.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class MyQuestionTableViewCell: BVQuestionTableViewCell {
  @IBOutlet weak var questionSummary : UILabel!
  @IBOutlet weak var questionDetails : UILabel!
  
  override var question: BVQuestion? {
    didSet {
      questionSummary.text = "\(question!.questionSummary!)  (\(question!.answers.count) Answers)"
      questionDetails.text = question!.questionDetails
    }
  }
}
