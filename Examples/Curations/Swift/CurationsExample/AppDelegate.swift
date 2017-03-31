//
//  AppDelegate.swift
//  CurationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
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
        
        return true

        
    }
    
}

