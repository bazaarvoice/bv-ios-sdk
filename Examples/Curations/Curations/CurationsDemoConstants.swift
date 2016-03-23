//
//  CurationsDemoConstants.swift
//  Curations Demp App
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import Foundation
import BVSDK

struct CurationsDemoConstants {
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // FIXME: Set up your client id and API key here first!
    
    static let API_KEY_CURATIONS = "REPLACE_ME"  // <--- Add your Curations API key here.
    static let CLIENT_ID = "REPLACE_ME"          // <--- Add your Curations Client ID here
    static let DEFAULT_FEED_GROUPS_CURATIONS = ["__all__"]  // This group is used as the default for both posting custom content and fetching feeds. Search the code for this use to customize your own for testing.
    static let BVSDK_IS_STAGING = true  // Set to false for production!
    
    ////////////////////////////////////////////////////////////
    
    static func isSDKConfigured() -> Bool {
        if (BVSDKManager.sharedManager().apiKeyCurations == "REPLACE_ME" ||
            BVSDKManager.sharedManager().clientId        == "REPLACE_ME"){
            return false
        }
        
        return true
    }
    
}