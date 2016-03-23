//
//  AppDelegate.swift
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

import UIKit
import BVSDK

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var settingsWindow: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {


        // TODO: Set up your client id and API key here first!
        let myClientId = ""
        let myShopperAdvertisingKey = ""
        

        
        let mgr = BVSDKManager.sharedManager()
        mgr.setLogLevel(BVLogLevel.Error)
        mgr.staging = false;
        mgr.apiKeyShopperAdvertising = myShopperAdvertisingKey
        mgr.clientId = myClientId
        
        self.setupAuthenticatedUser()
        
        let navController = UINavigationController(rootViewController: RootViewController())
        navController.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.translucent = false
        navController.navigationBar.barTintColor = UIColor.bazaarvoiceNavy()
        navController.navigationBar.barStyle = .Black;
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
        let clientId = BVSDKManager.sharedManager().clientId
        let passKey = BVSDKManager.sharedManager().apiKeyShopperAdvertising
        
        // must set clientId and passKey in the demo app before it will work.
        // please contact Bazaarvoice for these values.
        if (clientId == "" || passKey == ""){
            SweetAlert().showAlert("BVSDK not configured", subTitle: "To run this demo app, please set your shopperAdvertisingKey and clientId in AppDelegate.swift.", style: AlertStyle.Warning)
        }
        
        return true
    }
    
    func setupAuthenticatedUser() -> Void {
        /*
        Next, we have to tell BVSDK about the user. See the BVSDK wiki for more discussion on how to create this user auth string: https://github.com/bazaarvoice/bv-ios-sdk/wiki/BVSDK-UserAuthentication
        
        A user auth string would contain data in a query string format. For example:
        userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
        The list of keys allowed in the query string are defined in BVUser.h.
        */
        
        // Example MD5 encoded auth string used
    BVSDKManager.sharedManager().setUserWithAuthString("0ce436b29697d6bc74f30f724b9b0bb6646174653d31323334267573657269643d5265636f6d6d656e646174696f6e7353646b54657374")
        // pre-populated with a small profile interested in men's and women's apparel -- for testing and demonstration purposes.
    }
    
}
