//
//  CurationsFeedCellCollectionViewCell.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

class DemoCurationsCollectionViewCell: BVCurationsCollectionViewCell {

    let TAG_SOCIAL_ICON_IMAGE_VIEW = 99
    let TAG_PLAY_ICON_IMAGE_VIEW = 100
    
    @IBOutlet weak var feedImageView: UIImageView! {
        
        didSet {
        
            self.imageOffset = CGPoint(x: 0,y: 0)
        }
        
    }
    
    override var feedItem : BVCurationsFeedItem? {
        
        didSet {
            
            // remove any previously added images.
            for view : UIView in self.subviews {
                if view.tag == TAG_SOCIAL_ICON_IMAGE_VIEW || view.tag == TAG_PLAY_ICON_IMAGE_VIEW {
                    view.removeFromSuperview()
                }
            }
            
            if (self.feedItem!.videos.count > 0){
                
                let video : BVCurationsVideo = self.feedItem!.videos.first!;
                let imageUrl : NSURL = NSURL(string:video.imageServiceUrl)!
                
                self.feedImageView.sd_setImageWithURLWithFade(imageUrl, placeholderImage: UIImage(named: "loading"))
                
                self.addPlayMovieIconForCell(self, feedItem: self.feedItem!)
                
            }
            else if (self.feedItem!.photos.count > 0){
                
                let photo : BVCurationsPhoto = self.feedItem!.photos.first!;
                let imageUrl : NSURL = NSURL(string:photo.imageServiceUrl)!
                self.feedImageView.sd_setImageWithURLWithFade(imageUrl, placeholderImage: UIImage(named: "loading"))
                
            }
            
            self.addSociaIconForCell(self, feedItem: self.feedItem!)
            
        }
        
    }
    

    var imageOffset : CGPoint! {
        
        didSet {
        
            // Grow image view
            let frame : CGRect = self.feedImageView.bounds;
            let offsetFrame : CGRect = CGRectOffset(frame, imageOffset.x, imageOffset.y)
            self.feedImageView.frame = offsetFrame
    
        }
        
    }
    
    func addPlayMovieIconForCell(cell : DemoCurationsCollectionViewCell, feedItem : BVCurationsFeedItem){
        
        let imageView = UIImageView();
        let image = UIImage(named:"play")
        imageView.image = image
        imageView.tag = TAG_PLAY_ICON_IMAGE_VIEW
        
        cell.addSubview(imageView)
        
        // Pin to upper left
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalSpacing1 = NSLayoutConstraint(item: cell, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let verticalSpacing2 = NSLayoutConstraint(item: cell, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activateConstraints([verticalSpacing1, verticalSpacing2])
        
    }
    
    func addSociaIconForCell(cell : DemoCurationsCollectionViewCell, feedItem : BVCurationsFeedItem){
        
        var iconName : String?
        
        switch feedItem.channel {
        case "youtube":
            iconName = "youtube14"
            break
        case "instagram":
            iconName = "instagram"
            break
        case "pinterest":
            iconName = "pinterest13"
            break
        case "twitter":
            iconName = "twitter"
            break
        case "google-plus":
            iconName = "google_plus"
            break
        case "facebook":
            iconName = "facebook26"
            break
        case "bazaarvoice":
            iconName = "bv"
            break
            
        default: break // nothing to do.
        }
        
        if (iconName != nil){
            let imageView = UIImageView();
            let image = UIImage(named: iconName!)
            imageView.image = image
            imageView.tag = TAG_SOCIAL_ICON_IMAGE_VIEW
            cell.addSubview(imageView)
            
            // Pin to lower right
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            let verticalSpacing1 = NSLayoutConstraint(item: cell, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 12)
            
            let verticalSpacing2 = NSLayoutConstraint(item: cell, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 12)
            
            NSLayoutConstraint.activateConstraints([verticalSpacing1, verticalSpacing2])
            
        }
        
    }

    
    
}
