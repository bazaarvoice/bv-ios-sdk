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
        selectionStyle = .none
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        object.setValue(textField.text, forKeyPath: keyPath!)
    }
}
