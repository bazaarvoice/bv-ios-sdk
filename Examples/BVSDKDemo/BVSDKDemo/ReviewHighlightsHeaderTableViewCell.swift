//
//  ReviewHighlightsHeaderTableViewCell.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 27/03/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class ReviewHighlightsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view_CellBackground: UIView!
    @IBOutlet weak var view_Separator: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var imageView_: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
