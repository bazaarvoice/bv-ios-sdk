//
//  MyReviewTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class ReviewTitleTableViewCell: EditablePropertyTableViewCell, UITextFieldDelegate {

    @IBOutlet var reviewTextField: UITextField?
    
    override func awakeFromNib() {
        selectionStyle = .None
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        object.setValue(textField.text, forKeyPath: keyPath!)
    }
}
