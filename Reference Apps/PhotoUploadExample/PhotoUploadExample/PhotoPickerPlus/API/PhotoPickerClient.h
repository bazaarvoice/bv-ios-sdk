//
//  PhotoPickerClient.h
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/7/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "AFHTTPClient.h"

@class GCResponseStatus;

@interface PhotoPickerClient : AFHTTPClient

///--------------------------------
/// @name Creating Singleton object
///--------------------------------

/**
 Creates a singleton object for the httpClient.
*/

+ (PhotoPickerClient *)sharedClient;

///----------------------------------
/// @name Creating Request Operations
///----------------------------------

/**
 Sends a request to server.
 
 @param urlRequest The request object to be loaded asynchronously during execution of the operation.
 
 @param success A block object to be executed when the operation finishes successfully. This block has no return value and takes three arguments: the responseStatus from the server response, an array containing folders and an array containing files from the server response data.

 @param failure A block object to be executed when the operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: `NSError` object describing the network or parsing error that occurred.
 
 @warning This method require `GCResponseStatus` class. Add an `#import <Chute-SDK/GCResponseStatus.h>` in your header/implementation file.
*/
- (void)request:(NSMutableURLRequest *)request success:(void(^)(GCResponseStatus *responseStatus, NSArray *folders, NSArray *files))success failure:(void(^)(NSError *error))failure;

@end
