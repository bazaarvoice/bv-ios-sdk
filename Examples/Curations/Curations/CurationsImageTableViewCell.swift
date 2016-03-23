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
            self.rightChevronImageView.hidden = !self.hasNext!
        }
        
    }
    var hasPrev : Bool! {
        
        didSet {
            self.leftChevronImageView.hidden = !self.hasPrev!
        }
        
    }
    
    var feedItem : BVCurationsFeedItem? {
        
        didSet {
            print(self.feedItem)
            // remove previos play button is there was one.
            for view in self.subviews {
                
                if view.tag == 99 {
                    view.removeFromSuperview()
                }
                
            }
            
            if self.feedItem!.videos.count > 0 {
                // video post
                let video : BVCurationsVideo = self.feedItem!.videos.first!;
                let imageUrl : NSURL = NSURL(string:video.imageServiceUrl)!
                
                self.postImageView.sd_setImageWithURLWithFade(imageUrl, placeholderImage: UIImage(named: "loading"))
                
                let playIconSizeWidth : CGFloat = 88.0;
                
                let imageView = UIImageView();
                let image = UIImage(named:"play")
                imageView.image = image
                imageView.frame.size = CGSizeMake(playIconSizeWidth, playIconSizeWidth)
                imageView.tag = 99
                imageView.center = CGPointMake(self.frame.size.width  / 2 + playIconSizeWidth/2,
                    self.frame.size.height / 2);
                
                self.addSubview(imageView)
                
            } else {
                
                // social post image
                let photo : BVCurationsPhoto = self.feedItem!.photos.first!;
                let imageUrl : NSURL = NSURL(string:photo.imageServiceUrl)!
                self.postImageView?.sd_setImageWithURLWithFade(imageUrl, placeholderImage: UIImage(named: ""))
                
                // Add tap gesture on image
                let tapImageGesture = UITapGestureRecognizer(target: self, action: "tappedImage:")
                self.postImageView.userInteractionEnabled = true
                self.postImageView.addGestureRecognizer(tapImageGesture)
                
                self.rightChevronImageView.userInteractionEnabled = true
                self.leftChevronImageView.userInteractionEnabled = true
                
            }

        }

        
    }
        
    func tappedImage(sender:UITapGestureRecognizer){
       
        // open safari - go to author's page
        let url = NSURL(string: self.feedItem!.permalink)
        UIApplication.sharedApplication().openURL(url!)
        
    }
    
}
