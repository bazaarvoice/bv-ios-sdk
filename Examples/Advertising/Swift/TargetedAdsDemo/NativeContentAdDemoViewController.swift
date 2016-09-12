//
//  NativeContentAdDemoViewController.swift
//  TargetedAdsDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BVSDK

class NativeContentAdDemoViewController: UIViewController, GADNativeContentAdLoaderDelegate {

    var adLoader = GADAdLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Native Ad"
        // Do any additional setup after loading the view, typically from a nib.
        
        //Test adUnitId. Replace with your targeted adUnitId.
        adLoader = GADAdLoader(adUnitID: "/6499/example/native", rootViewController: self, adTypes: [kGADAdLoaderAdTypeNativeContent], options: nil)
        adLoader.delegate = self
        
        let request = DFPRequest()
        request.testDevices = [kGADSimulatorID]
        request.customTargeting = BVSDKManager.sharedManager().getCustomTargeting()
        adLoader.loadRequest(request)
    }
    
    
    @IBAction func closeButtonPressed() {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: GADNativeContentAdLoaderDelegate
    
    func adLoader(adLoader: GADAdLoader!, didReceiveNativeContentAd nativeContentAd: GADNativeContentAd!) {
        
        // configure our native content ad view with the given values, and display!
        
        let contentAdView = NSBundle.mainBundle().loadNibNamed("NativeContentAdView", owner: nil, options: nil)![0] as! GADNativeContentAdView
        
        // Associate the app install ad view with the app install ad object.
        // This is required to make the ad clickable.
        contentAdView.nativeContentAd = nativeContentAd;
        
        //let logoImage = nativeContentAd.logo.image as UIImage
        let adImage = (nativeContentAd.images[0] as! GADNativeAdImage).image
        let headlineText = nativeContentAd.headline
        let advertisterText = nativeContentAd.advertiser
        let bodyText = nativeContentAd.body
        let callToActionText = nativeContentAd.callToAction
        
        //(contentAdView.logoView as! UIImageView).image = logoImage
        (contentAdView.imageView as! UIImageView).image = adImage
        (contentAdView.headlineView as! UILabel).text = headlineText
        (contentAdView.advertiserView as! UILabel).text = advertisterText
        (contentAdView.bodyView as! UILabel).text = bodyText
        (contentAdView.callToActionView as! UIButton).setTitle(callToActionText, forState: UIControlState.Normal)
        
        
        // Populate the app install ad view with the app install ad assets.
        // In order for the SDK to process touch events properly, user interaction
        // should be disabled on UIButtons. Must be disabled in nib -- just highlighted here for completeness.
         contentAdView.callToActionView!.userInteractionEnabled = false;
        
        // size appropriately
        let padding = self.view.bounds.size.width * 0.1;
        contentAdView.frame = CGRectMake(padding,
                                    self.view.bounds.size.height * 0.18,
                                    self.view.bounds.size.width - padding*2,
                                    self.view.bounds.size.height * 0.4)
        
        // Add appInstallAdView to the view controller's view..
        self.view.addSubview(contentAdView)
        
        // add a border and shadow, just to highlight in this demo application
        contentAdView.layer.borderColor = UIColor.greenColor().CGColor
        contentAdView.layer.borderWidth = 0.5;
        contentAdView.layer.cornerRadius = 2;
        contentAdView.layer.shadowColor = UIColor.grayColor().CGColor
        contentAdView.layer.shadowOffset = CGSizeMake(0,5);
        contentAdView.layer.shadowRadius = 5;
        contentAdView.layer.shadowOpacity = 0.6;
        contentAdView.layer.masksToBounds = false;
        
    }
    
    func adLoader(adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
        UIAlertView(title: "Error", message: "Failed to get ad: " + error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        
    }


}
