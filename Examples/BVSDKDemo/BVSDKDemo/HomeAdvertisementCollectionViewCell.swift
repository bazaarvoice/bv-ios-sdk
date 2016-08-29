//
//  HomeAdvertisementCollectionViewCell.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeAdvertisementCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nativeContentAdView : GADNativeContentAdView!
    
    var nativeContentAd : GADNativeContentAd? {
        
        didSet{
            
            print("self " + (nativeContentAd?.headline)!)
            
            let titleLabel = nativeContentAdView.headlineView as! UILabel
            let imageView =  nativeContentAdView.imageView as! UIImageView
            let bodyLabel =  nativeContentAdView.bodyView as! UILabel
            let callToActionLabel = nativeContentAdView.callToActionView as! UILabel
            
            titleLabel.text = nativeContentAd?.headline
            imageView.image = (nativeContentAd?.images[0] as! GADNativeAdImage).image
            bodyLabel.text = nativeContentAd?.body
            callToActionLabel.text = nativeContentAd?.callToAction
            
            self.nativeContentAdView.nativeContentAd = nativeContentAd
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
