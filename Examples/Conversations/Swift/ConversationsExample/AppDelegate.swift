//
//  AppDelegate.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // TODO: DO NOT USE THIS CLIENTID FOR YOUR OWN APP. USE THE CLIENT ID PROVIDED BY BAZAARVOICE!!!
        BVSDKManager.sharedManager().apiKeyConversations = "KEY_REMOVED"
        BVSDKManager.sharedManager().clientId = "apitestcustomer"
        BVSDKManager.sharedManager().staging = true
        BVSDKManager.sharedManager().setLogLevel(.Verbose)
        
        return true
    }


}

