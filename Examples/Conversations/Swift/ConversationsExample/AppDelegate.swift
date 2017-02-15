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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        // TODO: DO NOT USE THIS CLIENTID FOR YOUR OWN APP. USE THE CLIENT ID PROVIDED BY BAZAARVOICE!!!
        BVSDKManager.shared().apiKeyConversations = "kuy3zj9pr3n7i0wxajrzj04xo"
        BVSDKManager.shared().clientId = "apireadonlysandbox"
        BVSDKManager.shared().staging = true
        BVSDKManager.shared().setLogLevel(.verbose)
        
        return true
    }
    

}

