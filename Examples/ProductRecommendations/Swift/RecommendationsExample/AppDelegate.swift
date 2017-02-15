//
//  AppDelegate.swift
//  RecommendationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        BVSDKManager.shared().clientId = "REPLACE_ME"
        BVSDKManager.shared().apiKeyShopperAdvertising = "REPLACE_ME"
        BVSDKManager.shared().staging = false;
        BVSDKManager.shared().setLogLevel(.verbose)
        
        // Example of hard-coded UAS token to set a user's profile
    BVSDKManager.shared().setUserWithAuthString("TOKEN_REMOVED")
        
        return true

    }
    
}

