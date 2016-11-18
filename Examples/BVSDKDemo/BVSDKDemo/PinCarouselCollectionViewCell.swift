//
//  PinCarouselCollectionViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDWebImage

class PinCarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var productImage: UIImageView?
    @IBOutlet private weak var prodDescLbl: UILabel?

    var pin: BVPIN! {
        didSet {
            prodDescLbl?.text = pin.name
            productImage?.sd_setImage(with: URL(string: pin.imageUrl))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
