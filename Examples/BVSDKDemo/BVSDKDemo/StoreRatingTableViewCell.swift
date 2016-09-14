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
        selectionStyle = .None
        starView?.addObserver(self, forKeyPath: "value", options: [.New], context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === starView {
            let val = Int(starView!.value)
            self.object.setValue(val, forKeyPath: self.keyPath)
            starLbl?.text = String(format: "I Rate This Store %d %@", val, val > 1 ? "Stars" : "Star")
        }else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}
