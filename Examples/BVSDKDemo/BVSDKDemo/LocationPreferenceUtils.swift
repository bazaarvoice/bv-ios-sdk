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
        let identifier = aDecoder.decodeObject(forKey: "storeId") as! String
        var city = aDecoder.decodeObject(forKey: "city") as? String
        var state = aDecoder.decodeObject(forKey: "state") as? String
        
        if city == nil {
            city = ""
        }
        
        if state == nil {
            state = ""
        }
        
        self.init(storeId: identifier, city: city!, state: state!)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: "storeId")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(state, forKey: "state")
    }
    
}

class LocationPreferenceUtils {
    
    static func isDefaultStoreId(_ storeId : String!) -> Bool {
        
        let defaultCachedStore = self.getDefaultStore()
        if (defaultCachedStore?.identifier == storeId){
            return true
        }

        return false
    }
    
    static func setDefaultStore(_ store: CachableDefaultStore){
        
        let archivedStore = NSKeyedArchiver.archivedData(withRootObject: store)
        
        let defaults = UserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo.app")
        defaults!.set(archivedStore, forKey: "DefaultBVStore")
        defaults!.synchronize()

    }
    
    static func getDefaultStore() -> CachableDefaultStore? {
        
        if let savedStoreData = UserDefaults(suiteName: "group.bazaarvoice.bvsdkdemo.app")?.object(forKey: "DefaultBVStore") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: savedStoreData) as? CachableDefaultStore
        }
        
        return nil
        
    }
    
    static func isDefaultStore(_ store: BVStore) -> Bool {
    
        var isDefault = false
        
        if let defaultStore = self.getDefaultStore(){
            if (defaultStore.identifier == store.identifier){
                isDefault = true
            }
        }
        
        return isDefault
    }
    
}

