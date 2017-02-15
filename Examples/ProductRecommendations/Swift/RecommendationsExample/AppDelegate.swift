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
    BVSDKManager.shared().setUserWithAuthString("0ce436b29697d6bc74f30f724b9b0bb6646174653d31323334267573657269643d5265636f6d6d656e646174696f6e7353646b54657374")
        
        return true

    }
    
}

