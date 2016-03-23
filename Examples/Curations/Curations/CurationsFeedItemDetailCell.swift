//
//  CurationsFeedItemDeailCell.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

enum SocialOutlet {
    case Pinterest
    case Twitter
    case Email
    case ReplyComment
    case Retweet
    case UserProfile
}


class CurationsFeedItemDetailCell: UITableViewCell {

    var isFavorite = false
    
    @IBOutlet weak var starButton: UIButton!
    
    @IBOutlet weak var authorImage: UIImageView!

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    
    var feedItem : BVCurationsFeedItem? {
        
        didSet {
            
            // author image
            let author : BVCurationsPostAuthor = (self.feedItem?.author)!
            let avatarURL : NSURL = NSURL(string:author.avatar)!
            self.authorImage?.sd_setImageWithURLWithFade(avatarURL, placeholderImage: UIImage(named: ""))
            
            let postDate = NSDate(timeIntervalSince1970: (feedItem?.timestamp.doubleValue)!)
            self.postTimeLabel.text = dateTimeAgo(postDate)
            
            if (author.profile != nil && author.username != nil){
                self.linkAuthorNameLabel(author.profile, author: author.username)
            } else {
                self.authorNameLabel.text = author.username
            }
            
            self.postTextLabel.text = feedItem?.text
        }
        
    }
    
    func linkAuthorNameLabel(url : String, author : String) {
        
        let attributes = [ NSForegroundColorAttributeName: UIColor.blueColor() ]
        let attrText = NSAttributedString(string: author, attributes: attributes)
        
        self.authorNameLabel.attributedText = attrText
        self.authorNameLabel.userInteractionEnabled = true
        
        let tapAuthorGesture = UITapGestureRecognizer(target: self, action: "tappedAuthor:")
        self.authorNameLabel.addGestureRecognizer(tapAuthorGesture)
    }
    
    func tappedAuthor(sender:UITapGestureRecognizer){
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(socialOutlet : SocialOutlet.UserProfile, product: self.feedItem!)
        }
    }
    
    @IBAction func didTapPinterestButton(sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(socialOutlet : SocialOutlet.Pinterest, product: self.feedItem!)
        }
        
    }
    
    
    @IBAction func didTapTwitterButton(sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(socialOutlet : SocialOutlet.Twitter, product: self.feedItem!)
        }
    }
    
    
    @IBAction func didTapEmailButton(sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(socialOutlet : SocialOutlet.Email, product: self.feedItem!)
        }
    }
    
    
    @IBAction func didTapReplyButton(sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(socialOutlet : SocialOutlet.ReplyComment, product: self.feedItem!)
        }
    }
    
    
    @IBAction func didTapRetweetButton(sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(socialOutlet : SocialOutlet.Retweet, product: self.feedItem!)
        }
    }
    
    @IBAction func toggleStarTapped(sender: AnyObject) {
        
        isFavorite = !isFavorite
        
        let imageName = isFavorite ? "star_filled" : "star_unfilled"
        
        self.starButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        
    }
    
    
    var onSocialButtonTapped : ((socialOutlet : SocialOutlet, product : BVCurationsFeedItem) -> Void)? = nil
    
}



