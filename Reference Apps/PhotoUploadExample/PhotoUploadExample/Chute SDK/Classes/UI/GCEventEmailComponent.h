//
//  GCEventEmail.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 9/15/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

//simple component for getting a MFMailComposeViewController that has all attendees of an event as the recipients and a subject and message pre-entered.
//You must link MessageUI, AddressBook, and Eventkit frameworks to the project to use this class.

#import <Foundation/Foundation.h>
#import "GetChute.h"
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>
#import <AddressBook/AddressBook.h>

@interface GCEventEmailComponent : NSObject <MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) id delegate;

//message and subject are optional, if dates are not supplied it will set start to 30 days ago and end to 30 days from now.
+(MFMailComposeViewController*)MailViewControllerForEventNamed:(NSString*)event afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end withMessage:(NSString*)message andSubject:(NSString*)subject;

+(NSArray*)atendeeEmailsForEventNamed:(NSString*)eventName afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end;

+(EKEvent*)eventNamed:(NSString*)eventName afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end;

+(void)findAtendeesAndEventNamed:(NSString*)eventName afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end withCompletionBlock:(void (^)(EKEvent*, NSArray*))aCompletionBlock andErrorBlock:(GCErrorBlock)errorBlock;
@end
