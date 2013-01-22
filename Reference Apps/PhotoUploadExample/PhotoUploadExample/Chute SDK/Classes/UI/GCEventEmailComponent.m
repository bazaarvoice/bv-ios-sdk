//
//  GCEventEmail.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 9/15/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCEventEmailComponent.h"

@implementation GCEventEmailComponent
@synthesize delegate;


+(MFMailComposeViewController*)MailViewControllerForEventNamed:(NSString*)eventName afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end withMessage:(NSString*)message andSubject:(NSString*)subject{
    if(!eventName)
        return NULL;
    NSArray *emailAddresses = [GCEventEmailComponent atendeeEmailsForEventNamed:eventName afterEventStartDate:start beforeEventEndDate:end];
        if(emailAddresses){
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        [vc setToRecipients:emailAddresses];
        if(message)
            [vc setMessageBody:message isHTML:YES];
        if(subject)
            [vc setSubject:subject];
        return [vc autorelease];
    }
    return NULL;
}


+(NSArray*)atendeeEmailsForEventNamed:(NSString*)eventName afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end{
    if(!eventName)
        return NULL;
    EKEvent *foundEvent = [GCEventEmailComponent eventNamed:eventName afterEventStartDate:start beforeEventEndDate:end];
    if(foundEvent){
        NSArray *attendees = foundEvent.attendees;
        NSMutableArray *emailAddresses = [NSMutableArray array];
        if(attendees){
            for(EKParticipant *attendant in attendees){
                NSString *email = [[attendant URL] absoluteString];
                NSRange range = [email rangeOfString:@"mailto:"];
                if(range.location != NSNotFound){
                    email = [email stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
                    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
                    
                    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg]; 
                    
                    if (!(([emailTest evaluateWithObject:email] != YES) || [email isEqualToString:@""]))
                        [emailAddresses addObject:email];
                }
            }
        }
        return emailAddresses;
    }
    return NULL;
}

+(EKEvent*)eventNamed:(NSString*)eventName afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end{
    if(!eventName)
        return NULL;
    EKEventStore *store = [[[EKEventStore alloc] init] autorelease];
    if(!start){
        CFGregorianDate gregorianStartDate;
        CFGregorianUnits startUnits = {0, 0, -30, 0, 0, 0};
        CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
        gregorianStartDate = CFAbsoluteTimeGetGregorianDate(
                                                            CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, startUnits),
                                                            timeZone);
        gregorianStartDate.hour = 0;
        gregorianStartDate.minute = 0;
        gregorianStartDate.second = 0;
        start =
        [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianStartDate, timeZone)];
        CFRelease(timeZone);
    }
    if(!end){
        CFGregorianDate gregorianEndDate;
        CFGregorianUnits endUnits = {0, 0, 30, 0, 0, 0};
        CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
        gregorianEndDate = CFAbsoluteTimeGetGregorianDate(
                                                          CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, endUnits),
                                                          timeZone);
        gregorianEndDate.hour = 0;
        gregorianEndDate.minute = 0;
        gregorianEndDate.second = 0;
        end =
        [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianEndDate, timeZone)];
        CFRelease(timeZone);
    }
    NSPredicate *predicate = [store predicateForEventsWithStartDate:start endDate:end calendars:nil];
    NSArray *array = [store eventsMatchingPredicate:predicate];
    EKEvent *foundEvent = NULL;
    for(EKEvent *event in array){
        if([event.title caseInsensitiveCompare:eventName] == NSOrderedSame){
            foundEvent = event;
        }
    }
    return foundEvent;
}

+(void)findAtendeesAndEventNamed:(NSString*)eventName afterEventStartDate:(NSDate*)start beforeEventEndDate:(NSDate*)end withCompletionBlock:(void (^)(EKEvent*, NSArray*))aCompletionBlock andErrorBlock:(GCErrorBlock)errorBlock{
    EKEvent *_event = [GCEventEmailComponent eventNamed:eventName afterEventStartDate:start beforeEventEndDate:end];
    if(!_event){
        errorBlock([NSError errorWithDomain:@"Event not found" code:404 userInfo:NULL]);
        return;
    }
    NSArray *_attendees = _event.attendees;
    NSMutableArray *emailAddresses = [NSMutableArray array];
    if(_attendees){
        for(EKParticipant *attendant in _attendees){
            NSString *email = [[attendant URL] absoluteString];
            NSRange range = [email rangeOfString:@"mailto:"];
            if(range.location != NSNotFound){
                email = [email stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
                NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
                
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg]; 
                
                if (!(([emailTest evaluateWithObject:email] != YES) || [email isEqualToString:@""]))
                    [emailAddresses addObject:email];
            }
        }
    }
    aCompletionBlock(_event, _attendees);
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
