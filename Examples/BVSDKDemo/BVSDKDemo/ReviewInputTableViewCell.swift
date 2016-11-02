//
//  ReviewInputTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class ReviewInputTableViewCell: EditablePropertyTableViewCell, UITextViewDelegate {

    @IBOutlet var reviewTextView: MPTextView?
    var viewToMoveUp: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewTextView?.placeholderText = "My review..."
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let view = viewToMoveUp else {
            return
        }
        
        var frame = view.frame
        frame.origin.y = -180
        
        UIView.animate(withDuration: 0.25, animations: { () in
            view.frame = frame
        }) 
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            resetFrame()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        object.setValue(textView.text, forKeyPath: keyPath)
        resetFrame()
    }
    
    private func resetFrame() {
        guard let view = viewToMoveUp else {
            return
        }
        var frame = view.frame
        frame.origin.y = 0
        UIView.animate(withDuration: 0.25, animations: { () in
            view.frame = frame
        }) 
    }
}
