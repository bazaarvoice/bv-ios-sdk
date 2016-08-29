//
//  ProfileUtils.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import Crashlytics
import FBSDKLoginKit
import BVSDK

public class ProfileUtils: NSObject {

    var loginProfile = [String : String]()
    
    class var sharedInstance: ProfileUtils {
        struct Singleton {
            static let instance: ProfileUtils = ProfileUtils()
        }
        return Singleton.instance
    }
    
    
    public class func trackFBLogin(identifier : String) {
        
        Answers.logLoginWithMethod("Facebook",
                                   success: true,
                                   customAttributes: ["name":identifier])
        
    }
    
    public class func trackViewController(theObject : AnyObject) {
        
        Answers.logContentViewWithName(String(theObject.dynamicType),
                                       contentType: "View Controller",
                                       contentId: "",
                                       customAttributes: [:])
        
    }
    
    
    public class func isFabricInstalled() -> Bool {
        
        let fabricAPIKey = NSBundle.mainBundle().infoDictionary?["Fabric"]!["APIKey"] as? String
        if ((fabricAPIKey?.isEmpty) == false) {
            return true
        }

        return false
    }
    
    public class func isFacebookInstalled() -> Bool {
        
        let fbAppID = NSBundle.mainBundle().infoDictionary?["FacebookAppID"] as? String
        if ((fbAppID?.isEmpty) == false) {
            return true;
        }
        
        return false
    }
    
    func logOut() {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        
    }
    
    func setUserAuthString() {
    
        if(FBSDKAccessToken.currentAccessToken() == nil) {
            return;
        }
        
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender,hometown,age_range"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
        
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            
            if(error == nil)
            {
                
                let formatter: NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                let dateTimePrefix: String = formatter.stringFromDate(NSDate())
                
                var userProfileDict: [String : String] = [
                    "date" : dateTimePrefix,
                ]
                
                if let fbID = result.valueForKey("id") {
                    userProfileDict["facebookId"] = fbID as? String
                }
                
                if let gender = result.valueForKey("gender") {
                    userProfileDict["gender"] = gender as? String
                }
                
                if let emailAddr = result.valueForKey("email") {
                    userProfileDict["email"] = emailAddr as? String
                } 
                
                if let name = result.valueForKey("name") {
                    userProfileDict["name"] = name as? String
                }
                
                self.loginProfile.removeAll()
                self.loginProfile = userProfileDict
                
                // This macro section here with SITE_AUTH is shows you might make an asynchronous call
                // to generate a user authentication string for setting profile information.
                if SITE_AUTH == 1 {
                    BVUserAuthStringGenerator.generateUAS(userProfileDict, withCompletion: { (uas, error) in
                        if (error == nil){
                            BVSDKManager.sharedManager().setUserWithAuthString(uas)
                        } else {
                            print("An error occurred generating the UAS.");
                        }
                    })
                    
                }
            }
            else
            {
                print("error \(error)")
            }
        })

    }
    
}
