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
        
        // FIXME: Add your own Curations client id and API key here!
        BVSDKManager.shared().clientId = "bazaarvoice"
        BVSDKManager.shared().apiKeyCurations = "r538c65d7d3rsx2265tvzfje"
        BVSDKManager.shared().staging = true;
        BVSDKManager.shared().setLogLevel(.verbose)
        
        return true

        
    }
    
}

