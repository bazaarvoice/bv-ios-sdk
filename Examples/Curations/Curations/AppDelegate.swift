//
//  AppDelegate.swift
//  Curations Demo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
                
        let mgr = BVSDKManager.sharedManager()
        mgr.setLogLevel(BVLogLevel.Verbose)
        mgr.staging = CurationsDemoConstants.BVSDK_IS_STAGING;
        mgr.apiKeyCurations = CurationsDemoConstants.API_KEY_CURATIONS
        mgr.clientId = CurationsDemoConstants.CLIENT_ID

        return true
    }

}

