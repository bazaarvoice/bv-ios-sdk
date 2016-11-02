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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        _ = MockDataManager.sharedInstance // start data mocking service
        
        BVSDKManager.shared().setLogLevel(.error)
        BVSDKManager.shared().clientId = "REPLACE_ME"
        BVSDKManager.shared().apiKeyCurations = "REPLACE_ME"
        BVSDKManager.shared().apiKeyConversations = "REPLACE_ME"
        BVSDKManager.shared().apiKeyShopperAdvertising = "REPLACE_ME"
        //BVSDKManager.shared().apiKeyLocation = "00000000-0000-0000-0000-000000000000" // Setting the location key will initialize the location manager
        BVSDKManager.shared().apiKeyConversationsStores = "REPLACE_ME"
        //"The value for UNNotificationExtensionCategory as defined by your Extension's info.plist that will be used to notify a user to review a store"
        BVSDKManager.shared().storeReviewContentExtensionCategory = "bvReviewCustomContent"
        BVSDKManager.shared().staging = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        self.setupAuthenticatedUser()
        
        if (ProfileUtils.isFabricInstalled()) {
            self.setupFabric()
        }
        
        if (ProfileUtils.isFacebookInstalled()) {
            FBSDKProfile.enableUpdates(onAccessTokenChange: true)
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        //Must be set before this method returns
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self;
        }
            
            
        if (ProfileUtils.isFacebookInstalled()) {
            FBSDKProfile.enableUpdates(onAccessTokenChange: true)
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        //Must be set before this method returns
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self;
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if (ProfileUtils.isFacebookInstalled()) {
            FBSDKAppEvents.activateApp()
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if (url.scheme == "bvsdkdemo") {
            
            /*
             bvsdkdemo://bvsdk.com?type=reivew&subtype=store&id=1
             */
            let urlStr = url.absoluteString
            let keyRange = urlStr.range(of: "id=")
            let storeId = urlStr.substring(from: keyRange!.upperBound)
            
            delay(0.5, closure: {
                let vc = StoreWriteReviewViewController(nibName:"StoreWriteReviewViewController", bundle: nil)
                vc.storeId = storeId
                let nc = UINavigationController(rootViewController: vc)
                self.window?.rootViewController?.present(nc, animated: true, completion:nil)
            })
            
            return true
            
        } else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func setupAuthenticatedUser() -> Void {
        
        /*
         Next, we have to tell BVSDK about the user. See the BVSDK wiki for more discussion on how to create this user auth string: https://bazaarvoice.github.io/bv-ios-sdk/user_authentication_token.html
         
         A user auth string would contain data in a query string format. For example:
         userid=Example&email=user@example.com&age=28&gender=female&facebookId=123abc
         The list of keys allowed in the query string are defined in BVUser.h.
         
         Example auth string given below.
         Pre-populated with a small profile interested in men's and women's apparel -- for testing and demonstration purposes.
         */
        if SITE_AUTH != 1 {
            BVSDKManager.shared().setUserWithAuthString("TOKEN_REMOVED")
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
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        BVReviewNotificationCenter.shared().handleAction(withIdentifier: identifier, for: notification)
        
        if identifier == ID_REPLY {
            delay(0.5, closure: {
                let vc = StoreWriteReviewViewController(nibName:"StoreWriteReviewViewController", bundle: nil)
                vc.storeId = notification.userInfo![USER_INFO_PROD_ID] as? String;
                let nc = UINavigationController(rootViewController: vc)
                self.window?.rootViewController?.present(nc, animated: true, completion:nil)
            })
        }
        completionHandler()
    }
    
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Must forward to BVSDK
        BVReviewNotificationCenter.shared().userNotificationCenter(center, didReceive: response)
        
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // User tapped on the notification itself, but not a specific action.
            // Here you can determine to just let the app open, or respond to the response
            // by pushing a desired view controller.
            print("Default action selected on notification: " + response.description)
            
            let vc = StoreWriteReviewViewController(nibName:"StoreWriteReviewViewController", bundle: nil)
            let userInfoDict = response.notification.request.content.userInfo
            vc.storeId = userInfoDict[USER_INFO_PROD_ID] as? String
            let nc = UINavigationController(rootViewController: vc)
            self.window?.rootViewController?.present(nc, animated: true, completion:nil)
            
        } else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            // User decided to dismiss the view controller
            // Handle any app logic, if desired.
        }
        
        completionHandler()
    }
}
