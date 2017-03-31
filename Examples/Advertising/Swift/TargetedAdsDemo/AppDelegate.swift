//
//  AppDelegate.swift
//  TargetedAdsDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // #warning See bvsdk_config_staging.json and bvsdk_config_product.json in the project for API key and client ID settings.
        BVSDKManager.configure(.staging)
        BVSDKManager.shared().setLogLevel(.verbose)
        
        self.setupAuthenticatedUser()
        
        return true
    }

    func setupAuthenticatedUser() -> Void {
        
        /*
         Next, we have to tell BVSDK about the user. See the BVSDK wiki for more discussion on how to create this user auth string: https://github.com/bazaarvoice/bv-ios-sdk/wiki/BVSDK-UserAuthentication
         
         A user auth string would contain data in a query string format. For example:
         userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
         The list of keys allowed in the query string are defined in BVUser.h.
         
         Example auth string given below.
         Pre-populated with a small profile interested in men's and women's apparel -- for testing and demonstration purposes.
         */
        BVSDKManager.shared().setUserWithAuthString("TOKEN_REMOVED")
        
    }
    
}

