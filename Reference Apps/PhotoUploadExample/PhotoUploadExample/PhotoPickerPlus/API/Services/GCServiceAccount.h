//
//  GCServiceAccount.h
//  Chute-SDK
//
//  Created by ARANEA on 7/30/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus;

@interface GCServiceAccount : NSObject

///-----------------------------------
/// @name Managing data from server
///-----------------------------------

/**
 Getting profile info from server. Sets the specified success and failure callbacks.
 
 @param success A block object to be executed when the operation finishes successfully. This block has no return value and takes two arguments: the responseStatus received from the server response, and an array object containing accounts of type `GCAccount` from the server response data.
 
 @param failure A block object to be executed when the operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: `NSError` object describing the network or parsing error that occurred.
 
 @warning This method require `GCResponseStatus` class. Add an `#import <Chute-SDK/GCResponseStatus.h>` in your header/implementation file.
*/
+ (void)getProfileInfoWithSuccess:(void(^)(GCResponseStatus *responseStatus,NSArray *accounts))success failure:(void (^)(NSError *error))failure;

/**
 Getting media data from server. Sets the specified success and failure callbacks.
 
 @param serviceName The name of the service for which we would like to receive media data. This argument must not be `nil`.
 
 @param accountID The ID of the account for which we would like to receive media data. This argument must not be `nil`.
 
 @param albumID The ID of the album from which we would like to pull media data. 
 
 @param success A block object to be executed when the operation finishes successfully. This block has no return value and takes three arguments: the responseStatus from the server response, an array containing folders of type `GCAccountAlbum` and an array containing files of type `GCAccountAssets` from the server response data.
 
 @param failure A block object to be executed when the operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: `NSError` object describing the network or parsing error that occurred.
 
 @warning This method require `GCResponseStatus` class. Add an `#import <Chute-SDK/GCResponseStatus.h>` in your header/implementation file.
*/
+ (void)getDataForServiceWithName:(NSString *)serviceName forAccountWithID:(NSNumber *)accountID forAlbumWithID:(NSNumber *)albumID success:(void(^)(GCResponseStatus *responseStatus,NSArray *folders, NSArray *files))success failure:(void(^)(NSError *error))failure;

/**
 Sending a post request for chosen assets, to be saved on server
 
 @param selectedImages An array of assets we selected. This argument must not be `nil`.
 
 @param success A block object to be executed when the operation finishes successfully. This block has no return value and takes two arguments: the responseStatus from the server response, an array containing asssets of type `GCAsset` from the server response data.
 
 @param failure A block object to be executed when the operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: `NSError` object describing the network or parsing error that occurred.
 
 @warning This method require `GCResponseStatus` class. Add an `#import <Chute-SDK/GCResponseStatus.h>` in your header/implementation file.
*/
+ (void)postSelectedImages:(NSArray *)selectedImages success:(void(^)(GCResponseStatus *responseStatus, NSArray *returnedArray))success failure:(void(^)(NSError *error))failure;

@end
