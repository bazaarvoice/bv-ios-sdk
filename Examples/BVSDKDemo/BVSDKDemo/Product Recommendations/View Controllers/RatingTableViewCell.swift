//
//  NewProductTableViewCell.swift
//  BVSDKDemo
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView
import BVSDK
import FontAwesomeKit

private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum Votes {
  case NoVote, UpVote, DownVote
}

class RatingTableViewCell: BVReviewTableViewCell {
  
  @IBOutlet weak var reviewText : UILabel!
  @IBOutlet weak var reviewTitle : UILabel!
  @IBOutlet weak var reviewAuthor : UILabel!
  @IBOutlet weak var reviewAuthorLocation : UILabel!
  @IBOutlet weak var reviewStars : HCSStarRatingView!
  @IBOutlet weak var reviewPhoto : UIImageView!
  
  @IBOutlet weak var thumbUpButton: UIButton!
  @IBOutlet weak var thumbDownButton: UIButton!
  
  @IBOutlet weak var commentsButton: UIButton!
  
  @IBOutlet weak var upVoteCountLabel: UILabel!
  @IBOutlet weak var downVoteCountLabel: UILabel!
  @IBOutlet weak var totalCommentsLabel: UILabel!
  
  var totalCommentCount = 0
  var totalUpVoteCount = 0
  var totalDownVoteCount = 0
  
  var onAuthorNickNameTapped : ((_ authorId : String) -> Void)? = nil
  var onCommentIconTapped : ((_ reviewComments : [BVComment]) -> Void)? = nil
  var onVoteIconTapped : ((_ voteDict: NSDictionary) -> Void)? = nil
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.updateStatisticIcons()
  }
  
  private func updateStatisticIcons() {
    
    self.upVoteCountLabel.text = String(self.totalUpVoteCount)
    self.downVoteCountLabel.text = String(self.totalDownVoteCount)
    self.totalCommentsLabel.text = String(self.totalCommentCount)
    
    let commentsIconColor = self.totalCommentCount > 0 ? UIColor.bazaarvoiceTeal().withAlphaComponent(1) :UIColor.lightGray.withAlphaComponent(0.5)
    
    let thumbDownColor = self.vote == Votes.DownVote ? UIColor.bazaarvoiceTeal().withAlphaComponent(1) :UIColor.lightGray.withAlphaComponent(0.5)
    let thumbUpColor = self.vote == Votes.UpVote ? UIColor.bazaarvoiceTeal().withAlphaComponent(1) :UIColor.lightGray.withAlphaComponent(0.5)
    
    self.thumbUpButton.setBackgroundImage(getIconImage(FAKFontAwesome.thumbsUpIcon(withSize:), color: thumbUpColor), for: .normal)
    self.thumbDownButton.setBackgroundImage(getIconImage(FAKFontAwesome.thumbsDownIcon(withSize:), color: thumbDownColor), for: .normal)
    self.commentsButton.setBackgroundImage(getIconImage(FAKFontAwesome.commentIcon(withSize:), color: commentsIconColor), for: .normal)
    
  }
  
  func getIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome!), color: UIColor) -> UIImage {
    
    let size = CGFloat(22)
    
    let newIcon = icon(size)
    newIcon?.addAttribute(
      NSForegroundColorAttributeName,
      value: color
    )
    
    return newIcon!.image(with: CGSize(width: size, height: size))
    
  }
  
  var vote : Votes = Votes.NoVote {
    
    didSet {
      
      if vote == Votes.UpVote {
        self.voteButtonTapped(self.thumbUpButton)
        totalUpVoteCount += 1
      } else if vote == Votes.DownVote {
        self.voteButtonTapped(self.thumbDownButton)
        totalDownVoteCount += 1
      }
      
      updateStatisticIcons()
      
    }
    
  }
  
  override var review : BVReview? {
    
    didSet {
      
      // set the review text, while increasing line spacing
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 5
      
      let attrString = NSMutableAttributedString(string: review!.reviewText ?? "")
      attrString.addAttribute(
        NSParagraphStyleAttributeName,
        value: paragraphStyle,
        range: NSMakeRange(0, attrString.length)
      )
      
      reviewText.attributedText = attrString
      
      reviewTitle.text = review!.title
      reviewStars.value = CGFloat(review!.rating)
      if let photoUrl = review?.photos.first?.sizes?.normalUrl {
        reviewPhoto.sd_setImage(with: URL(string: photoUrl))
      }
      else {
        reviewPhoto.image = nil
      }
      
      if let submissionTime = review?.submissionTime, let nickname = review?.userNickname {
        let fullString = dateTimeAgo(submissionTime) + " by " + nickname
        self.reviewAuthor.linkAuthorNameLabel(fullText: fullString, author: nickname, target: self, selector: #selector(RatingTableViewCell.tappedAuthor(_:)))
      }
      else if let nickname = review?.userNickname {
        self.reviewAuthor.linkAuthorNameLabel(fullText: nickname, author: nickname, target: self, selector: #selector(RatingTableViewCell.tappedAuthor(_:)))
      }
      else if let submissionTime = review?.submissionTime {
        reviewAuthor.text = dateTimeAgo(submissionTime) + " by Anonymous"
      }
      else {
        reviewAuthor.text = "Anonymous"
      }
      
      if let authorLocation = review?.userLocation {
        reviewAuthorLocation.text = authorLocation
      }
      else {
        reviewAuthorLocation.text = ""
      }
      
      self.totalUpVoteCount = (review?.totalPositiveFeedbackCount?.intValue)!
      self.totalDownVoteCount = (review?.totalNegativeFeedbackCount?.intValue)!
      self.totalCommentCount = (review?.totalCommentCount?.intValue)!
      
      self.updateStatisticIcons()
      
      self.setNeedsLayout()
      
    }
    
  }
  
  func tappedAuthor(_ sender:UITapGestureRecognizer){
    if let onAuthorNameTapped = self.onAuthorNickNameTapped {
      onAuthorNameTapped((review?.authorId)!)
    }
  }
  
  
  @IBAction func voteButtonTapped(_ sender: Any) {
    
    if vote != Votes.NoVote { return }
    
    let button = sender as! UIButton
    
    if (button === self.thumbDownButton) {
      vote = Votes.DownVote
    } else if (button === self.thumbUpButton) {
      vote = Votes.UpVote
    }
    
    updateStatisticIcons()
    
    // let any listener know what the vote was
    tapVoteCallback(vote: vote)
  }
  
  
  @IBAction func commentsButtonTapped(_ sender: Any) {
    if let onCommentTapped = self.onCommentIconTapped, totalCommentCount > 0 {
      onCommentTapped((review?.comments)!)
    }
  }
  
  func tapVoteCallback(vote : Votes){
    
    // Send callback if set
    if let onVoteTapped = self.onVoteIconTapped {
      if let reviewId = self.review?.identifier {
        let result : NSDictionary = [reviewId:vote]
        onVoteTapped(result)
      }
    }
    
    // TODO: Here we would record an API call for the feedback vote from the use
    // However, Feedback API doesn't support a Preview functionality, so we'll skip that for now.
    
  }
  
}
