//
//  RecommendStoreTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class RecommendStoreTableViewCell: EditablePropertyTableViewCell {

    @IBOutlet var yesBtn: UIButton?
    @IBOutlet var noBtn: UIButton?
    private var isRecommended: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        formatButton(yesBtn!, selected: true)
        formatButton(noBtn!, selected: false)
    }
    
    private func formatButton(btn: UIButton, selected: Bool) {
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.lightGrayColor().CGColor
        btn.layer.borderWidth = 1
        markButtonSelected(btn, selected: selected)
    }
    
    private func markButtonSelected(btn: UIButton, selected: Bool) {
        if selected {
            btn.backgroundColor = UIColor(colorLiteralRed: 0, green: 122.0 / 255.0, blue: 1, alpha: 1)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }else{
            btn.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    @IBAction func noSelected(sender: AnyObject) {
        isRecommended = false
        updateSelection(isRecommended!)
    }
    
    @IBAction func yesSelected(sender: AnyObject) {
        isRecommended = true
        updateSelection(isRecommended!)
    }
    
    private func updateSelection(recommended: Bool) {
        object.setValue(recommended, forKeyPath: keyPath)
        
        if recommended {
            formatButton(yesBtn!, selected: true)
            formatButton(noBtn!, selected: false)
        }else {
            formatButton(yesBtn!, selected: false)
            formatButton(noBtn!, selected: true)
        }
    }
}
