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
+(void)registerForLocationUpdates:(id<BVLocationManagerDelegate> _Nonnull)delegate;

/**
    Delegate will be unregistered so it will stop receiving callbacks
*/
+(void)unregisterForLocationUpdates:(id<BVLocationManagerDelegate> _Nonnull)delegate;

/**
    Set the single delegate that will handle formatting a push notification and deciding whether to show or not.
*/
+(void)setNotificationDelegate:( __weak id<BVLocationNotificationDelegate> _Nullable)delegate;

/**
    Start updating location; All registered delegates will receive callbacks
*/
+(void)startLocationUpdates;

/**
    Stop updating location; All registered delegates will stop receiving callbacks
*/
+(void)stopLocationUpdates;

@end


@class BVVisit;
@protocol BVLocationManagerDelegate <NSObject>

/// All registered delegates will receive this callback whenever a user enters a store belonging to the client of the SDK.
@optional
-(void)didBeginVisit:(BVVisit* _Nonnull)visit;

/// All registered delegates will receive this callback whenever a user exits a store belonging to the client of the SDK.
@optional
-(void)didEndVisit:(BVVisit* _Nonnull)visit;

@end

@protocol BVLocationNotificationDelegate<NSObject>

/**
    Only performed if Application is not in the foreground
    Called before presenting a notification.
    @param The location for where the notification is to be presented
    @return YES if you would like the notification presented or NO if not.
 */
@required
-(BOOL)shouldShowNotificationForVisit:(BVVisit* _Nonnull)visit;

/**
    Only performed if Application is not in the foreground
    Called before presenting a notification.
    @param notification A notification containing preconfigured information that can be modified.
    @return The notification to be presented. If nil is returned preconfigured notification will be shown.
 */
@required
-( UILocalNotification* _Nonnull )notificationWillBePresented:(UILocalNotification* _Nonnull)notification;

@end