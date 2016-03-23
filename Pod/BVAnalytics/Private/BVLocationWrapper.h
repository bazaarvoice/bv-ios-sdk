//
//  BVLocationWrapper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



// BVLocationWrapper is a holder object that is used to hold and pass around Locaton event data.
@interface BVLocationWrapper : NSObject

@property NSString* contextualTier1;
@property NSString* contextualTier2;
@property CLLocation* location;

@end
