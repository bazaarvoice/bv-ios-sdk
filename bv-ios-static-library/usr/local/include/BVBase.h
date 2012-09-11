//
//  BVBase.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSettings.h"
#import "BVResponse.h"
#import "BVParameters.h"

#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V126"

@class BVBase;


/*!
 BVDelegate is a protocol which notifies the client of API request status updates. Each request is guaranteed to result in one of either didReceiveResponse: or didFailToReceiveResponse:.  All submission requests will generate one or more didSendBodyData: callbacks.
 */
@protocol BVDelegate <NSObject>
@optional
/*!
 Delegate callback for the case that the request is successful.
 @param response The deserialized response.
 @param request The object which generated the request.
 */
- (void) didReceiveResponse:(BVResponse*)response forRequest:(BVBase*)request;
/*!
 Delegate callback to indicate that body data has been sent as part of this request.  This method will only be called for submission requests and will be called one or more times as the data is sent.
 @param bytesWritten The number of bytes written in this update.
 @param totalBytesWritten The total number of bytes written for this entire request.
 @param totalBytesExpectedToWrite The total number of bytes expected to be written as part of this request.
 @param request The object which generated the request.
 */
- (void) didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite forRequest:(BVBase*)request;

/*!
 Delegate callback for the case that the request fails.
 @param err Contains specifics about the error.
 @param request The object which generated the request.
 */
- (void) didFailToReceiveResponse:(NSError*)err forRequest:(BVBase*)request;
@end


/*!
 BVBase is the base class for all API calls.  It should never be used directly. Instead, use the BVDisplay\* or BVSubmit\* subclass for a particular api call.
 */
@interface BVBase : NSObject <NSURLConnectionDelegate> {
    NSMutableData *dataToReceive; // Receive our data here.
    NSString *_rawURLRequest;
}

/*!
 The client delegate to receive BVDelegate notifications.
 */
@property (nonatomic, unsafe_unretained) id<BVDelegate> delegate;
/*!
 Holds a reference to the BVParameters or one if its subclasses that is used to generate the API request.
 */
@property (nonatomic, strong) BVParameters* parameters;


// Overrides for subclasses


//Read only property that contains the final URL request string to be sent to the server.
@property (nonatomic, readonly) NSString* rawURLRequest;

//Contains a reference to BVSettings storing the passkey, API and other common parameters. By default it is set to the singleton object [BVSettings instance].
@property (nonatomic, strong) BVSettings* settingsObject;

//Read only property declaration to access the final parameter URL generated for the buildURL method.
@property (nonatomic, readonly) NSString* parameterURL; // If parameters go into the URL, then this contains the string.

// The content type of the submission request if any. For example, this is used to decode the content type or is over ridden in BVSubmissionPhoto as a parameter to the request.
@property (nonatomic, readonly) NSString *contentType;

// Must always be overridden in sub classes to the appropriate values. Sets the API method name before “.json” and the contentType in the BVResponse header.
@property (nonatomic, readonly) NSString* displayType;

// Override this function in subclass if want to build a fragment different from default
- (NSString*) fragmentForKey:(NSString*)key usingDictionary:(NSDictionary*)parametersDict; 

// Override for building URL requeststrings
- (NSString*) buildURLString; 

//Override for generating the URL request. 
- (NSMutableURLRequest*) generateURLRequestWithString:(NSString*)string;

/*!
 This method kicks off the asynchronous API request.  The delegate will receive updates via the BVDelegate protocol.
 */
- (void) startAsynchRequest;
@end