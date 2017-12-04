//
//  BVLocationManager.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BVLocationManagerDelegate;
@protocol BVLocationNotificationDelegate;

@interface BVLocationManager : NSObject

/**
    Register a delegate to BVLocationManagerDelegate callbacks
    Can register multiple delegates to receive callbacks
*/
+ (void)registerForLocationUpdates:
    (nonnull id<BVLocationManagerDelegate>)delegate;

/**
    Delegate will be unregistered so it will stop receiving callbacks
*/
+ (void)unregisterForLocationUpdates:
    (nonnull id<BVLocationManagerDelegate>)delegate;

/**
    Start updating location; All registered delegates will receive callbacks
*/
+ (void)startLocationUpdates;

/**
    Stop updating location; All registered delegates will stop receiving
   callbacks
*/
+ (void)stopLocationUpdates;

@end

@class BVVisit;
@protocol BVLocationManagerDelegate <NSObject>

/// All registered delegates will receive this callback whenever a user enters a
/// store belonging to the client of the SDK.
@optional
- (void)didBeginVisit:(nonnull BVVisit *)visit;

/// All registered delegates will receive this callback whenever a user exits a
/// store belonging to the client of the SDK.
@optional
- (void)didEndVisit:(nonnull BVVisit *)visit;

@end
