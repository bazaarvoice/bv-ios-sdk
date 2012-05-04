//
//  BVBase.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//


/*!
 @header BVBase
 BVBase is the base class for all API calls.  It should never be called directly. Instead, its subclasses should override the necessary parameters and functions to generate a specific API call. 
 */



#import <Foundation/Foundation.h>
#import "BVSettings.h"
#import "BVResponse.h"
#import "BVParameters.h"

#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V1"

@class BVBase;

/*!
 @protocol BVDelegate
 This is the delegate protocol 
 */
@protocol BVDelegate <NSObject>
@optional
- (void) didReceiveResponse:(BVResponse*)response forRequest:(BVBase*)request;
- (void) didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite forRequest:(BVBase*)request;
- (void) didFailToReceiveResponse:(NSError*)err forRequest:(BVBase*)request;
@end

@interface BVBase : NSObject <NSURLConnectionDelegate> {
    NSMutableData *dataToReceive; // Receive our data here.
    NSString *_rawURLRequest;
}

/*!
 The client delegate which will receive BVDelegate notifications
 */
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

/*!
 Override for generating the URL request. 
 @param string
 URL
 @result
 R in a URLRequest for the provided url.
 */
- (NSMutableURLRequest*) generateURLRequestWithString:(NSString*)string; // 

/*!
 This is the only method called by the instantiating class. It executes an asynchronous API request and will call one of 2 methods declared in the BVDelegate protocol.
 */
- (void) startAsynchRequest;
@end