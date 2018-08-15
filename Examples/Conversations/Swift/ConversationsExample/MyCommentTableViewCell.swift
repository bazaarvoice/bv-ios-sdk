//
//  MyCommentTableViewCell.swift
//  ConversationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class MyCommentTableViewCell: UITableViewCell {
  @IBOutlet var commentTitle: UILabel!
  @IBOutlet var commentLabel: UILabel!
  
  var comment : BVComment? {
    didSet {
      commentTitle.text = comment?.title ?? ""
      commentLabel.text = comment?.commentText ?? "Error"
    }
  }
}
