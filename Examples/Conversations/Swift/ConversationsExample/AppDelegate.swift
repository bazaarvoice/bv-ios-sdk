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
        
        // TODO: DO NOT USE THIS CLIENTID FOR YOUR OWN APP. USE THE CLIENT ID PROVIDED BY BAZAARVOICE (used to log into the Workbench).
        BVSDKManager.sharedManager().clientId = "apireadonlysandbox"
        BVSDKManager.sharedManager().apiKeyConversations = "kuy3zj9pr3n7i0wxajrzj04xo"
        BVSDKManager.sharedManager().staging = true
        BVSDKManager.sharedManager().setLogLevel(.Verbose)
        
        return true
    }


}

