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
    var settingsWindow: UIWindow?
    var navController = MenuController()
    var settingsViewController : SettingsViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // ****************
        // Configure the BVSDK correctly, or exit the app.
        
        var myClientId : String?
        var myShopperAdvertisingKey : String?
        
        // TODO: Set up your client id and API key here first!
        myClientId = ""
        myShopperAdvertisingKey = ""
        
        if (myClientId!.characters.count > 0  && myShopperAdvertisingKey!.characters.count > 0){
            
            let mgr = BVSDKManager.sharedManager()
            mgr.setLogLevel(BVLogLevel.Info)
            mgr.staging = false;
            mgr.apiKeyShopperAdvertising = myShopperAdvertisingKey!
            mgr.clientId = myClientId!
            
        } else {
            
            // fail, user needs to add in their own client id and shopper advertising key
            
            let alert : UIAlertController = UIAlertController(title: "BVSDK Not Configured!", message: "Please set your Shopper Advertising Key and Client Id in AppDelegate.swift!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                exit(1)
            }
            
            alert.addAction(OKAction)
            
            let rootViewController = UIViewController()
            
            self.navController.addChildViewController(rootViewController)
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.rootViewController = navController
            self.window!.makeKeyAndVisible()
            
            rootViewController.presentViewController(alert, animated: true, completion: { () -> Void in
            })
            
            return true;
        }
        
        // Successful BVSDK setup
        
        self.setupAuthenticatedUser()
        
        let settingsVC = SettingsViewController(nibName:"SettingsViewController", bundle: nil)
        self.settingsWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.settingsWindow!.rootViewController = settingsVC
        settingsWindow?.makeKeyAndVisible()
        
        let rootViewController = RootViewController()
        
        self.navController.addChildViewController(rootViewController)
        navController.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.translucent = false
        navController.navigationBar.barTintColor = UIColor.bazaarvoiceNavy()
        navController.navigationBar.barStyle = .Black;
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
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
    
    // MARK: Convenience methods for the setting menu
    
    func hideStars() -> Bool {
        return SettingsViewController.hideStars()
    }
    
    func useCustomStars() -> Bool {
        return SettingsViewController.useCustomStars()
    }
    
    func starsColor() -> UIColor {
        return SettingsViewController.starColor()
    }
    
    func closeSettingsMenu() -> Void {
        self.navController.closeMenu()
    }
    
    func openSettingsMenu() -> Void {
        self.navController.openAndCloseMenu()
    }
    
}
