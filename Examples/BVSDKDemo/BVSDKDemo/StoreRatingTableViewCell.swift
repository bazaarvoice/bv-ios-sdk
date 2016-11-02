//
//  StoreRatingCellTableViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

class StoreRatingTableViewCell: EditablePropertyTableViewCell {

    @IBOutlet var starView: HCSStarRatingView?
    @IBOutlet var starLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        starView?.addObserver(self, forKeyPath: "value", options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard object is HCSStarRatingView else {
            if (context != nil) {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
            }
            
            return
        }
        
        let val = Int(starView!.value)
        self.object.setValue(val, forKeyPath: self.keyPath)
        starLbl?.text = String(format: "I Rate This Store %d %@", val, val > 1 ? "Stars" : "Star")
        
    }
}
