//
//  ProductTableViewCell.swift
//  BVSDKDemo
//
//  Created by Abhinav Mandloi on 29/11/2019.
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var productPrice : UILabel!
    @IBOutlet weak var productStars : HCSStarRatingView!
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var productImageHeight : NSLayoutConstraint!
    @IBOutlet weak var view_Background: UIView!
    
    var product: SearchedProduct = SearchedProduct() {
        didSet {
            self.cellConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //Cell Configuration
    private func cellConfiguration() {
        self.productName.text = self.product.productName
        self.productImage.sd_setImage(with: URL(string: self.product.imageUrl))
    }
    
}
