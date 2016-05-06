//
//  DemoCollectionViewCell.swift
//  
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDWebImage

class DemoCollectionViewCell: BVCurationsCollectionViewCell {
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    override var feedItem : BVCurationsFeedItem? {
        
        didSet {
            
            let photo : BVCurationsPhoto = self.feedItem!.photos.first!
            let imageUrl : NSURL = NSURL(string:photo.imageServiceUrl)!
            self.feedImageView.sd_setImageWithURL(imageUrl)
            
        }
    }
}
