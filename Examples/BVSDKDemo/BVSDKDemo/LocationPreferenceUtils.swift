//
//  LocationPreferenceUtils.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import Foundation
import CoreLocation

class StoreLocation {
    
    var storeName, storeAddress, storeCity, storeState, storeZip, storeTel, storeId, latitude, longitude : String!
    var distainceInMilesFromCurrentLocation : CGFloat?
    
    init(dict : Dictionary<String, String>){
        
        self.storeName = dict["storeName"]
        self.storeAddress = dict["storeAddress"]
        self.storeCity = dict["storeCity"]
        self.storeState = dict["storeState"]
        self.storeZip = dict["storeZip"]
        self.storeTel = dict["storeTel"]
        self.storeId = dict["storeId"]
        self.latitude = dict["latitude"]
        self.longitude = dict["longitude"]
        
    }
    
    func getLocation() -> CLLocation {
        
        var storeLong = 0.0
        var storeLat = 0.0
        if let tmp = NSNumberFormatter().numberFromString(self.longitude) {
            storeLong = Double(tmp)
        }
        
        if let tmpLat = NSNumberFormatter().numberFromString(self.latitude) {
            storeLat = Double(tmpLat)
        }
        
        return CLLocation(latitude: storeLat, longitude: storeLong)
        
    }
    
}

class LocationPreferenceUtils {
    
    static let storeLocations : [StoreLocation]? = {
        
        guard let path = NSBundle.mainBundle().pathForResource("StoreLocations", ofType: "plist") else { return nil }
        guard let contents = NSArray(contentsOfFile: path) else { return nil }
        
        return contents.map{ StoreLocation(dict: $0 as! Dictionary) }
        
    }()
    
    
    static func setDefaultStore(store : StoreLocation?){
        
        let defaults = NSUserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo")
        var storeId = "0" // Store ID of 0 means no default is set
        if (store) != nil {
            storeId = store!.storeId
        }
        defaults!.setObject(storeId, forKey: "DefaultStoreLocation")
        defaults!.synchronize()
        
    }
    
    static func getDefaultStore() -> StoreLocation? {
        
        var store : StoreLocation?
        
        let defaults = NSUserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo")
        if let storeId = defaults!.stringForKey("DefaultStoreLocation"){
            for currStore in LocationPreferenceUtils.storeLocations! {
                if storeId == currStore.storeId {
                    store = currStore
                    break
                }
            }
        }
        
        return store
        
    }
    
    
    static func isDefaultStore(store : StoreLocation!) -> Bool {
        
        let defaultStore = self.getDefaultStore()
        if (defaultStore?.storeId == store.storeId){
            return true
        }

        return false
        
    }
    
    /// Calculate the distance in miles between two coordinates
    static func distanceInMilesFromLocation(locationA : CLLocation, locationB : CLLocation) -> CGFloat {
        
        let distanceMeters : CLLocationDistance = locationA.distanceFromLocation(locationB)
        
        return CGFloat(distanceMeters) / 1609.344
        
    }
    
}

