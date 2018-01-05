//
//  NewNativeAdCollectionViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewNativeAdCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var nativeContentAdView : GADNativeContentAdView!
  
  var nativeContentAd : GADNativeContentAd? {
    didSet {
      let headlineLabel = nativeContentAdView.headlineView as! UILabel
      let bodyLabel = nativeContentAdView.bodyView as! UILabel
      let imageView = nativeContentAdView.imageView as! UIImageView
      
      headlineLabel.text = nativeContentAd?.headline
      bodyLabel.text = nativeContentAd?.body
      let image = nativeContentAd?.images![0] as! GADNativeAdImage
      imageView.image = image.image
      
      nativeContentAdView.nativeContentAd = nativeContentAd
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}
