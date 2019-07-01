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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // start data mocking service
    
    //after adding your configuration files you may configure the BVSDK as follows;
    //.prod to use your production configuration and .staging for staging configuration
    
    let configType = BVConfigurationType.staging
    
    BVSDKManager.shared().setLogLevel(.verbose)
    
    MockDataManager.sharedInstance.configure(configType)
    
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
    return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
      BVSDKManager.shared().setUserWithAuthString("0ce436b29697d6bc74f30f724b9b0bb6646174653d31323334267573657269643d5265636f6d6d656e646174696f6e7353646b54657374")
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
  
  private func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
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
    completionHandler()
  }
}
