//
//  InterstitialDemo.swift
//  TargetedAdsDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BVSDK

class InterstitialDemo: NSObject, GADInterstitialDelegate{

    var interstitial : DFPInterstitial?
    var rootViewController : UIViewController?
    
    required  init(rootViewController : UIViewController) {
        
        self.rootViewController = rootViewController
        
    }
    
    func requestInterstitial(){
        
        interstitial = DFPInterstitial(adUnitID: "/6499/example/interstitial")  //Test adUnitId. Replace with your targeted adUnitId.
        interstitial?.delegate = self
        
        let request = DFPRequest()
        request.testDevices = [kGADSimulatorID]
        request.customTargeting = BVSDKManager.shared().getCustomTargeting()
        interstitial?.load(request)
        
    }
    
    // MARK: GADInterstitialDelegate
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        interstitial?.present(fromRootViewController: rootViewController!)
    }
    
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        UIAlertView(title: "Error", message: "Failed to get interstitial ad: " + error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
}
