//
//  AppDelegate.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        BVSDKManager.sharedManager().clientId = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyCurations = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyConversations = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyShopperAdvertising = "REPLACE_ME"
        BVSDKManager.sharedManager().staging = false
        BVSDKManager.sharedManager().setLogLevel(.Verbose)
        
        MockDataManager.sharedInstance // start data mocking service
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        self.setupAuthenticatedUser()
        
        return true
    }
    
    
    func setupAuthenticatedUser() -> Void {
        
        /*
            Next, we have to tell BVSDK about the user. See the BVSDK wiki for more discussion on how to create this user auth string: https://github.com/bazaarvoice/bv-ios-sdk/wiki/BVSDK-UserAuthentication

            A user auth string would contain data in a query string format. For example:
            userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
            The list of keys allowed in the query string are defined in BVUser.h.
         
            Example auth string given below.
            Pre-populated with a small profile interested in men's and women's apparel -- for testing and demonstration purposes.
         */
        BVSDKManager.sharedManager().setUserWithAuthString("TOKEN_REMOVED")
        
    }
    
    
    lazy var navController : BVDemoNavigationController = {
        
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeViewController.navigationItem.titleView = HomeViewController.createTitleLabel()
        let navController = BVDemoNavigationController(rootViewController:homeViewController)
        return navController
        
    }()
    
}

