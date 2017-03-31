//
//  DemoCarouselCollectionViewCell.swift
//  Bazaarvoice SDK Demo Application
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import HCSStarRatingView

class DemoCarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var starRating : HCSStarRatingView!
    
    var product: BVDisplayableProductContent? {
        
        didSet {
            self.productName.text = self.product?.displayName
            self.price.text = ""
            self.starRating.value = CGFloat(self.product?.averageRating ?? 0.0)
            
            if let url = self.product?.displayImageUrl {
                let imageUrl = URL(string: url)
                self.productImageView.sd_setImage(with: imageUrl)
            }else {
                self.productImageView.image = nil
            }
        }
    }
}
