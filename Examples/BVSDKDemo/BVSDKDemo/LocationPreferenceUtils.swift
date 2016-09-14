//
//  LocationPreferenceUtils.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import Foundation
import CoreLocation
import BVSDK

/// An NSUserDefaults cachable class that saves off some of the properties of a BVStore object so we can quickly get the user's default store selection. Only contains a subset of BVStore object properties.
class CachableDefaultStore : NSObject, NSCoding {
    
    var city, state, identifier : String!
    
    init(store : BVStore){
        
        if store.storeLocation?.city == nil && store.storeLocation?.state == nil {
            self.city = store.name
            self.state = ""
        } else {
            self.city = store.storeLocation?.city
            self.state = store.storeLocation?.state
        }
        
        self.identifier = store.identifier
    
    }
    
    init(storeId: String, city:String, state: String) {
        self.identifier = storeId
        
        self.city = city
        self.state = state
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let identifier = aDecoder.decodeObjectForKey("storeId") as! String
        var city = aDecoder.decodeObjectForKey("city") as? String
        var state = aDecoder.decodeObjectForKey("state") as? String
        
        if city == nil {
            city = ""
        }
        
        if state == nil {
            state = ""
        }
        
        self.init(storeId: identifier, city: city!, state: state!)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: "storeId")
        aCoder.encodeObject(city, forKey: "city")
        aCoder.encodeObject(state, forKey: "state")
    }
    
}

class LocationPreferenceUtils {
    
    static func isDefaultStoreId(storeId : String!) -> Bool {
        
        let defaultCachedStore = self.getDefaultStore()
        if (defaultCachedStore?.identifier == storeId){
            return true
        }

        return false
    }
    
    static func setDefaultStore(store: CachableDefaultStore){
        
        let archivedStore = NSKeyedArchiver.archivedDataWithRootObject(store)
        
        let defaults = NSUserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo")
        defaults!.setObject(archivedStore, forKey: "DefaultBVStore")
        defaults!.synchronize()

    }
    
    static func getDefaultStore() -> CachableDefaultStore? {
        
        if let savedStoreData = NSUserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo")?.objectForKey("DefaultBVStore") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(savedStoreData) as? CachableDefaultStore
        }
        
        return nil
        
    }
    
    static func isDefaultStore(store: BVStore) -> Bool {
    
        var isDefault = false
        
        if let defaultStore = self.getDefaultStore(){
            if (defaultStore.identifier == store.identifier){
                isDefault = true
            }
        }
        
        return isDefault
    }
    
}

