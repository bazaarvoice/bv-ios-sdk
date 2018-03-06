//
//  MyAnswerTableViewCell.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class MyAnswerTableViewCell: BVAnswerTableViewCell {
  
  @IBOutlet weak var answerTestLabel : UILabel!
  
  override var answer: BVAnswer? {
    didSet {
      answerTestLabel.text = answer?.answerText
    }
  }
  
  
}
