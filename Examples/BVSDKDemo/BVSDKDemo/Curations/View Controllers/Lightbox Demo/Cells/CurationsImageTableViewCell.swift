//
//  CurationsImageTableViewCell.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import SDWebImage

class CurationsImageTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var rightChevronImageView: UIImageView!
    @IBOutlet weak var leftChevronImageView: UIImageView!
    
    var hasNext : Bool! {
        
        didSet {
            self.rightChevronImageView.isHidden = !self.hasNext!
        }
        
    }
    var hasPrev : Bool! {
        
        didSet {
            self.leftChevronImageView.isHidden = !self.hasPrev!
        }
        
    }
    
    var feedItem : BVCurationsFeedItem? {
        
        didSet {
            print(self.feedItem!)
            // remove previos play button is there was one.
            for view in self.subviews {
                
                if view.tag == 99 {
                    view.removeFromSuperview()
                }
                
            }
            
            if self.feedItem!.videos.count > 0 {
                // video post
                let video : BVCurationsVideo = self.feedItem!.videos.first!;
                let imageUrl : URL = URL(string:video.imageServiceUrl)!
                
                self.postImageView.sd_setImageWithURLWithFade(imageUrl, placeholderImage: UIImage(named: "loading"))
                
                let playIconSizeWidth : CGFloat = 88.0;
                
                let imageView = UIImageView();
                let image = UIImage(named:"play")
                imageView.image = image
                imageView.frame.size = CGSize(width: playIconSizeWidth, height: playIconSizeWidth)
                imageView.tag = 99
                imageView.center = CGPoint(x: self.frame.size.width  / 2 + playIconSizeWidth/2,
                    y: self.frame.size.height / 2);
                
                self.addSubview(imageView)
                
            } else {
                
                // social post image
                if self.feedItem!.photos.count > 0 {
                    let photo : BVCurationsPhoto = self.feedItem!.photos.first!;
                    let imageUrl : URL = URL(string:photo.imageServiceUrl)!
                    self.postImageView?.sd_setImageWithURLWithFade(imageUrl, placeholderImage: UIImage(named: ""))
                }
                
                // Add tap gesture on image
                let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(CurationsImageTableViewCell.tappedImage(_:)))
                self.postImageView.isUserInteractionEnabled = true
                self.postImageView.addGestureRecognizer(tapImageGesture)
                
                self.rightChevronImageView.isUserInteractionEnabled = true
                self.leftChevronImageView.isUserInteractionEnabled = true
                
            }

        }

        
    }
        
    func tappedImage(_ sender:UITapGestureRecognizer){
       
        // open safari - go to author's page
        let url = URL(string: self.feedItem!.permalink)
        UIApplication.shared.openURL(url!)
        
    }
    
}
