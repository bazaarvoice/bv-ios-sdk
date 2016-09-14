//
//  QualitySliderTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class QualitySliderTableViewCell: EditablePropertyTableViewCell {

    private static let expressions = ["Poor", "Below Average" , "Average", "Above Average", "Excellent!"]
    private var selectIdx = 0;
    @IBOutlet var expressionLbl: UILabel?
    @IBOutlet var slider: UISlider?
    
    override var object: AnyObject! {
        didSet {
            if let _ = self.keyPath {
                let idx = object.valueForKeyPath(keyPath)!.integerValue - 1
                slider?.value = Float(Double(idx) * 0.25)
                sliderChanged(slider!)
                object.setValue(idx + 1, forKeyPath: keyPath)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    @IBAction func sliderChanged(sender: UISlider) {
        
        var newIdx: Int
        if sender.value < 0.2 {
            newIdx = 0
        }else if sender.value < 0.4 {
            newIdx = 1
        }else if sender.value < 0.6 {
            newIdx = 2
        }else if sender.value < 0.8 {
            newIdx = 3
        }else {
            newIdx = 4
        }

        sender.value = 0.25 * Float(newIdx)

        if selectIdx != newIdx {
            selectIdx = newIdx
            expressionLbl?.text = QualitySliderTableViewCell.expressions[selectIdx]
            if let _ = object, _ = keyPath {
                object.setValue(selectIdx + 1, forKeyPath: keyPath)
            }
        }
    }
}
