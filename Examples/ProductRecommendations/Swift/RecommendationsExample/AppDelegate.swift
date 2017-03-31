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
        // #warning See bvsdk_config_staging.json and bvsdk_config_product.json in the project for API key and client ID settings.
        BVSDKManager.configure(.prod)
        BVSDKManager.shared().setLogLevel(.verbose)
        
        // Example of hard-coded UAS token to set a user's profile
    BVSDKManager.shared().setUserWithAuthString("TOKEN_REMOVED")
        
        return true

    }
    
}

