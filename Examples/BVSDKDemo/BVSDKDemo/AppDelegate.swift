//
//  AppDelegate.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import Fabric
import Crashlytics
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        BVSDKManager.sharedManager().clientId = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyCurations = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyConversations = "REPLACE_ME"
        BVSDKManager.sharedManager().apiKeyShopperAdvertising = "REPLACE_ME"
        BVSDKManager.sharedManager().staging = false
        BVSDKManager.sharedManager().setLogLevel(.Info)

        MockDataManager.sharedInstance // start data mocking service
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        self.setupAuthenticatedUser()
        
        if (ProfileUtils.isFabricInstalled()) {
            self.setupFabric()
        }
        
        if (ProfileUtils.isFacebookInstalled()) {
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        if (ProfileUtils.isFacebookInstalled()) {
            FBSDKAppEvents.activateApp()
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        if SITE_AUTH != 1 {
        BVSDKManager.sharedManager().setUserWithAuthString("0ce436b29697d6bc74f30f724b9b0bb6646174653d31323334267573657269643d5265636f6d6d656e646174696f6e7353646b54657374")
        }
    
    }
    
    func setupFabric() {
        Fabric.with([Crashlytics.self, Answers.self])
    }
    
    
    lazy var navController : BVDemoNavigationController = {
        
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeViewController.navigationItem.titleView = HomeViewController.createTitleLabel()
        let navController = BVDemoNavigationController(rootViewController:homeViewController)
        return navController
        
    }()
    
}

