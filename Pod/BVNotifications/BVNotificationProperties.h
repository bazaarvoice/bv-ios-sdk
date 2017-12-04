//
//  BVNotificationProperties.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface BVNotificationProperties : NSObject

@property(nonatomic, assign, readonly) NSTimeInterval notificationDelay;

@property(nonatomic, strong, readonly) NSString *reviewPromtDispayText;
@property(nonatomic, strong, readonly) NSString *reviewPromptSubtitleText;
@property(nonatomic, strong, readonly) NSString *reviewPromptYesReview;
@property(nonatomic, strong, readonly) NSString *reviewPromtNoReview;
@property(nonatomic, strong, readonly) NSString *reviewPromptRemindText;
@property(nonatomic, assign, readonly) BOOL notificationsEnabled;
@property(nonatomic, strong, readonly) NSString *customUrlScheme;
@property(nonatomic, assign, readonly) BOOL requestReviewOnAppOpen;
@property(nonatomic, assign, readonly) NSTimeInterval visitDuration;
@property(nonatomic, assign, readonly) NSTimeInterval remindMeLaterDuration;
@property(nonatomic, strong, readonly) NSDate *allowableTimePeriodStart;
@property(nonatomic, strong, readonly) NSDate *allowableTimePeriodEnd;

- (id)initWithDictionary:(NSDictionary *)configDict;
@property(nonatomic, strong, readonly) NSDictionary *configDict;

@end
