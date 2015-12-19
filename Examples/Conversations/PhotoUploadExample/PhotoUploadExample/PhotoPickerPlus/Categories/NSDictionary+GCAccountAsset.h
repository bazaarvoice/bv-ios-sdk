//
//  NSDictionary+GCAccountAsset.h
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/30/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCAccountAssets,GCAsset;

@interface NSDictionary (GCAccountAsset)

///-------------------------------------
/// @name Creating custom NSDictionary
///-------------------------------------

/**
 Creates an NSDictionary from `GCAccountAssets` used to send post request to server.
 
 @param asset The `GCAccountAssets` object from which it should be created NSDictionary object
 
 @return `NSDictionary`
 
 @warning This method requires `GCAccountAssets` class. Add an `#import "GCAccountAssets.h"` to your header file.
 */
+ (NSDictionary *)dictionaryFromGCAccountAssets:(GCAccountAssets *)asset;

/**
 Creates an info NSDictionary from `GCAccountAssets`.
 
 @param asset The `GCAccountAssets` object from which it should be created NSDictionary object
 
 @return `NSDictionary`
 
 @warning This method requires `GCAccountAssets` class. Add an `#import "GCAccountAssets.h"` to your header file.
 */
+ (NSDictionary *)infoFromGCAccountAsset:(GCAccountAssets *)asset;

/**
 Creates an info NSDictionary from `GCAsset`.
 
 @param asset The `GCAsset` object from which it should be created NSDictionary object
 
 @return `NSDictionary`
 
 @warning This method requires `GCAsset` class. Add an `#import <Chute-SDK/GCAsset.h>` to your header file.
 */
+ (NSDictionary *)infoFromGCAsset:(GCAsset *)asset;

@end
