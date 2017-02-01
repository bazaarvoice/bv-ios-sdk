//
//  CurationsFeedItemDeailCell.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

enum SocialOutlet {
    case pinterest
    case twitter
    case email
    case replyComment
    case retweet
    case userProfile
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
            if (author.avatar != nil){
                let avatarURL : URL = URL(string:author.avatar)!
                self.authorImage?.sd_setImageWithURLWithFade(avatarURL, placeholderImage: UIImage(named: ""))
            }
            
            let postDate = Date(timeIntervalSince1970: (feedItem?.timestamp.doubleValue)!)
            self.postTimeLabel.text = dateTimeAgo(postDate)
            
            if (author.profile != nil && author.username != nil){
                self.linkAuthorNameLabel(author: author.username)
            } else {
                self.authorNameLabel.text = author.username
            }
            
            self.postTextLabel.text = feedItem?.text
        }
        
    }
    
    func linkAuthorNameLabel(author : String) {
        
        let attributes = [ NSForegroundColorAttributeName: UIColor.blue ]
        let attrText = NSAttributedString(string: author, attributes: attributes)
        
        self.authorNameLabel.attributedText = attrText
        self.authorNameLabel.isUserInteractionEnabled = true
        
        let tapAuthorGesture = UITapGestureRecognizer(target: self, action: #selector(CurationsFeedItemDetailCell.tappedAuthor(_:)))
        self.authorNameLabel.addGestureRecognizer(tapAuthorGesture)
    }
    
    func tappedAuthor(_ sender:UITapGestureRecognizer){
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(SocialOutlet.userProfile, self.feedItem!)
        }
    }
    
    @IBAction func didTapPinterestButton(_ sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(SocialOutlet.pinterest, self.feedItem!)
        }
        
    }
    
    @IBAction func didTapTwitterButton(_ sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(SocialOutlet.twitter, self.feedItem!)
        }
    }
    
    
    @IBAction func didTapEmailButton(_ sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(SocialOutlet.email, self.feedItem!)
        }
    }
    
    
    @IBAction func didTapReplyButton(_ sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(SocialOutlet.replyComment, self.feedItem!)
        }
    }
    
    
    @IBAction func didTapRetweetButton(_ sender: AnyObject) {
        if let onSocialButtonTapped = self.onSocialButtonTapped {
            onSocialButtonTapped(SocialOutlet.retweet, self.feedItem!)
        }
    }
    
    @IBAction func toggleStarTapped(_ sender: AnyObject) {
        
        isFavorite = !isFavorite
        
        let imageName = isFavorite ? "star_filled" : "star_unfilled"
        
        self.starButton.setImage(UIImage(named: imageName), for: UIControlState())
        
    }
    
    
    var onSocialButtonTapped : ((_ socialOutlet : SocialOutlet, _ product : BVCurationsFeedItem) -> Void)? = nil
    
}



