//
//  ViewController.swift
//  TargetedAdsDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var interstitialDemo : InterstitialDemo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BVAdvertising Example"
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func nativeAdTapped(sender: AnyObject) {
        
        let vc = NativeContentAdDemoViewController()
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func interstitialAdTapped(sender: AnyObject) {

        interstitialDemo = InterstitialDemo(rootViewController: self)
        interstitialDemo?.requestInterstitial()
        
    }
    
    
    
    @IBAction func bannerAdTapped(sender: AnyObject) {
        
        let vc = BannerDemoViewController()
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    
       
}

