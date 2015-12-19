//
//  AppDelegate.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let mgr = BVSDKManager.sharedManager()
        mgr.setLogLevel(BVLogLevel.Verbose)
        mgr.apiKeyShopperAdvertising = "4qhps77enfpw3kghuu8wendy"
        mgr.clientId = "apitestcustomer"
        mgr.staging = false;
        
        /*
        Next, we have to tell BVSDKManager about the user. See the github README for more discussion on how to create this user auth string.
        
        A user auth string would contain data in a query string format. For example:
        userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
        The list of keys allowed in the query string are defined in BVUser.h.
        */
        
        // Example MD5 encoded auth string used
    mgr.setUserWithAuthString("0ce436b29697d6bc74f30f724b9b0bb6646174653d31323334267573657269643d5265636f6d6d656e646174696f6e7353646b54657374")
        // pre-populated with a small profile interested in men's and women's apparel -- for testing and demonstration purposes.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let rootViewController = RootViewController()
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.translucent = false
        navController.navigationBar.barTintColor = UIColor.bazaarvoiceNavy()
        navController.navigationBar.barStyle = .Black;
        
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
        return true
    }


}

