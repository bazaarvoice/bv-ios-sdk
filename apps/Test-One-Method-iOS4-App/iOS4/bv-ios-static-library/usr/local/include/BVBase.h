//
//  BVDisplay.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSettings.h"
#import "BVResponse.h"
#import "BVParameters.h"

#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V1"

@class BVBase;

@protocol BVDelegate <NSObject>
@optional
- (void) didReceiveResponse:(BVResponse*)response sender:(BVBase*)senderID;
- (void) didFailToReceiveResponse:(NSError*)err sender:(BVBase*)senderID;
@end

@interface BVBase : NSObject <NSURLConnectionDelegate> {
    NSMutableData *dataToReceive; // Receive our data here.
    NSString *_rawURLRequest;
}

@property (nonatomic, unsafe_unretained) id<BVDelegate> delegate;
@property (nonatomic, strong) BVParameters* parameters;
@property (nonatomic, readonly) NSString* rawURLRequest;
@property (nonatomic, strong) BVSettings* settingsObject;
@property (nonatomic, readonly) NSString* parameterURL; // If parameters go into the URL, then this contains the string.
// The content type of the submission request if any. This is used to decode the content type or is over ridden in BVSubmissionPhoto
// as a parameter to the request.
@property (nonatomic, readonly) NSString *contentType;

// Overrides for subclasses
@property (nonatomic, readonly) NSString* displayType;
- (NSString*) fragmentForKey:(NSString*)key usingDictionary:(NSDictionary*)parametersDict; // Override this function in subclass if want to build a fragment different from default
- (NSString*) buildURLString; // Override for building URL requeststrings
- (NSMutableURLRequest*) generateURLRequestWithString:(NSString*)string; // Override for generating the URL request.

// Methods
- (void) startAsynchRequest;
@end