/**
 * Copyright (C) 2015 Gimbal, Inc. All rights reserved.
 *
 * This software is the confidential and proprietary information of Gimbal, Inc.
 *
 * The following sample code illustrates various aspects of the Gimbal SDK.
 *
 * The sample code herein is provided for your convenience, and has not been
 * tested or designed to work on any particular system configuration. It is
 * provided AS IS and your use of this sample code, whether as provided or
 * with any modification, is at your own risk. Neither Gimbal, Inc.
 * nor any affiliate takes any liability nor responsibility with respect
 * to the sample code, and disclaims all warranties, express and
 * implied, including without limitation warranties on merchantability,
 * fitness for a specified purpose, and against infringement.
 */

@class GMBLExperienceManager;
@class GMBLAction;

/// The delegate object to receive experience events.
@protocol GMBLExperienceManagerDelegate <NSObject>

@optional

/*!
 This will be invoked when a user receives an experience. An array of received GMBLActions
 will be passed to the app for filtering. Return an array of experiences you would like presented.
 This is optional, all experiences will be presented if this is not implemented.
 @param experienceManager
 @param receivedActions An array of all the experiences received for an event
 @return Array of experiences that you would like to be presented.
 */
- (NSArray *)experienceManager:(GMBLExperienceManager *)experienceManager
                 filterActions:(NSArray *)receivedActions;


/*!
 This will be invoked for each experience returned from experienceManager:filterActions:
 delegate method. The view controller with content for that specific experience will be
 returned for the application to display.
 @param manager
 @param actionViewController ViewController with the media for the recieved action.
 @param action The recieved action
 */
- (void)experienceManager:(GMBLExperienceManager *)experienceManager
    presentViewController:(UIViewController *)actionViewController
                forAction:(GMBLAction *) action;

/*!
 This method will be invoked when a notification is received after the action is returned
 from experienceManager:filterActions:, if implemented. The caller is given a chance to
 customize this notification. Caller should return a customized UILocalNotification for
 the SDK to use for the notification. SDK will use the default notification if null is
 returned from this method.
 @param manager
 @param notification Notification with the default message associated with the action
 @param action Recevied action.
 @return A UILocalNotification with any customization made to it.
 */
- (UILocalNotification *)experienceManager:(GMBLExperienceManager *)manager
             prepareNotificationForDisplay: (UILocalNotification *)notification
                          forAction:(GMBLAction *)action;


@end


/*!
 The Experience Manager defines the interface for delivering experiences defined in the Gimbal Experience Manager to your Gimbal SDK enabled application. 
 This class can be used to start and stop monitoring for experiences, as well as checking if you are currently monitoring.
 */
@interface GMBLExperienceManager : NSObject

@property (weak, nonatomic) id <GMBLExperienceManagerDelegate> delegate;

/// Returns the monitoring status of ExperienceManager
+ (BOOL)isMonitoring;

/// Starts listening for experiences based off place events.
+ (void)startExperiences;

/// Stops listening for experiences based off place events.
+ (void)stopExperiences;

/*!
 Used to parse a Gimbal Action from a local notification
 @param notification The local notification
 @return a GMBLAction if the UILocalNotification is a GMBLAction, else nil
 */
+ (GMBLAction *)actionForLocalNotification:(UILocalNotification *)notification;

/*!
 Used to trigger the action received from a notification.
 @param action The action parsed out of a notification
 */
+ (void)didReceiveExperienceAction:(GMBLAction *)action;

/*!
 Used to set market segment tags. This call overwrites the previously stored set of market segment tags.
 @param set of NSString tags
 */
+ (void)setSegmentTags:(NSSet *)segments;

/*!
 Used to retrieve the current market segment tags.
 @return the current set of market segment tags
 */
+ (NSSet *)getSegmentTags;

@end

