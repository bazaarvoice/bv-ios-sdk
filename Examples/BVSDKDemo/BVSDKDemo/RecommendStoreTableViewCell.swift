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
        self.selectionStyle = .none
        formatButton(yesBtn!, selected: true)
        formatButton(noBtn!, selected: false)
    }
    
    private func formatButton(_ btn: UIButton, selected: Bool) {
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        markButtonSelected(btn, selected: selected)
    }
    
    private func markButtonSelected(_ btn: UIButton, selected: Bool) {
        if selected {
            btn.backgroundColor = UIColor(colorLiteralRed: 0, green: 122.0 / 255.0, blue: 1, alpha: 1)
            btn.setTitleColor(UIColor.white, for: UIControlState())
        }else{
            btn.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
            btn.setTitleColor(UIColor.black, for: UIControlState())
        }
    }
    
    @IBAction func noSelected(_ sender: AnyObject) {
        isRecommended = false
        updateSelection(isRecommended!)
    }
    
    @IBAction func yesSelected(_ sender: AnyObject) {
        isRecommended = true
        updateSelection(isRecommended!)
    }
    
    private func updateSelection(_ recommended: Bool) {
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
