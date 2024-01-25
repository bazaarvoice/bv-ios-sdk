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

open class ProfileUtils: NSObject {
  
  var loginProfile = [String : String]()
  
  class var sharedInstance: ProfileUtils {
    struct Singleton {
      static let instance: ProfileUtils = ProfileUtils()
    }
    return Singleton.instance
  }
  
  
  open class func trackFBLogin(_ identifier : String) {
    
    Answers.logLogin(withMethod: "Facebook",
                     success: true,
                     customAttributes: ["name":identifier])
    
  }
  
  open class func trackViewController(_ theObject : AnyObject) {
    
    Answers.logContentView(withName: String(describing: type(of: theObject)),
                           contentType: "View Controller",
                           contentId: "",
                           customAttributes: [:])
    
  }
  
  
  open class func isFabricInstalled() -> Bool {
    
    if let fabricKey = Bundle.main.infoDictionary?["Fabric"] as? [String:Any] {
      if (fabricKey["APIKey"] as? String) != nil {
        return true
      }
    }
    
    return false
  }
  
  open class func isFacebookInstalled() -> Bool {
    
    let fbAppID = Bundle.main.infoDictionary?["FacebookAppID"] as? String
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
    
    if(FBSDKAccessToken.current() == nil) {
      return;
    }
    
    let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender,hometown,age_range"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
    
    _ = req?.start(completionHandler: { (connection, result, error) -> Void in
      
      if(error == nil)
      {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateTimePrefix: String = formatter.string(from: Date())
        
        var userProfileDict: [String : String] = [
          "date" : dateTimePrefix,
          ]
        
        
        let tResult = result as? [String:String]
        
        if let fbID = tResult?["id"] {
          userProfileDict["facebookId"] = fbID
        }
        
        if let gender = tResult?["gender"] {
          userProfileDict["gender"] = gender
        }
        
        if let emailAddr = tResult?["email"] {
          userProfileDict["email"] = emailAddr
        } 
        
        if let name = tResult?["name"] {
          userProfileDict["name"] = name
        }
        
        self.loginProfile.removeAll()
        self.loginProfile = userProfileDict
        
        // This macro section here with SITE_AUTH is shows you might make an asynchronous call
        // to generate a user authentication string for setting profile information.
        if SITE_AUTH == 1 {
          BVUserAuthStringGenerator.generateUAS(userProfileDict, withCompletion: { (uas, error) in
            if (error == nil){
              BVSDKManager.shared().setUAS(uas!)
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
