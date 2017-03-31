//
//  BannerDemoViewController.swift
//  TargetedAdsDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BVSDK

class BannerDemoViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bannerView: DFPBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Banner Ad"
        
        // Request the banner ad
        self.bannerView.adUnitID = "/6499/example/banner" //Test adUnitId. Replace with your targeted adUnitId.
        self.bannerView.rootViewController = self;
        
        let request = DFPRequest()
        request.testDevices = [ kGADSimulatorID ]
        request.customTargeting = BVSDKManager.shared().getCustomTargeting()
        
        bannerView.load(request)
        self.view.addSubview(self.bannerView)
        
    }

    
    @IBAction func closeButtonPressed() {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }

}
