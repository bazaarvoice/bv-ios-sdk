//
//  JPSThumbnailAnnotation+Curations.swift
//  BVSDKDemo
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSDK
import ObjectiveC

private var feedItemAssociationKey: UInt8 = 0

extension JPSThumbnailAnnotation {
  
  convenience init(curationsFeedItem: BVCurationsFeedItem, action: @escaping () -> Void ) {
    let thumbNail = JPSThumbnail()
    
    thumbNail.title = curationsFeedItem.author.username
    thumbNail.subtitle = curationsFeedItem.channel
    thumbNail.imageURL = URL(string: curationsFeedItem.photos[0].imageServiceUrl)
    thumbNail.coordinate = CLLocationCoordinate2DMake(curationsFeedItem.coordinates.latitude.doubleValue, curationsFeedItem.coordinates.longitude.doubleValue)
    
    thumbNail.disclosureBlock = {
      action()
    }
    
    self.init(thumbnail: thumbNail)
    objc_setAssociatedObject(self, &feedItemAssociationKey, curationsFeedItem, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
  }
  
  var curationsFeedItem: BVCurationsFeedItem! {
    get {
      return objc_getAssociatedObject(self, &feedItemAssociationKey) as! BVCurationsFeedItem
    }
  }
}
