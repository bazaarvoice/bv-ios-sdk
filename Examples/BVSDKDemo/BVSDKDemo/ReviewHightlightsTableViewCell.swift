//
//  ReviewHightlightsTableViewCell.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 27/03/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class ReviewHightlightsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view_CellBackground: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_CellBackground.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBgViewBorder(color: UIColor) {
        self.view_CellBackground.layer.borderColor = color.cgColor
        self.view_CellBackground.layer.borderWidth = 1
    }
    
}
