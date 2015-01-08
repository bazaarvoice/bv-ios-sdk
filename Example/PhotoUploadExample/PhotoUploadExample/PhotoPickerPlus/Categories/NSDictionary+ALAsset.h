//
//  NSDictionary+ALAsset.h
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/6/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset,GCAccountAssets;

@interface NSDictionary (ALAsset)

///-----------------------------------
/// @name Creating custom NSDictionary
///-----------------------------------

/**
 Creates `NSDictionary` from `ALAsset`.
 
 @param asset The `ALAsset` object from which it should be created NSDictionary object
 
 @return `NSDictionary`
 
 @warning This method requires `ALAsset` class. Add an `#import <AssetsLibrary/ALAsset.h>` to your header file.
*/
+ (NSDictionary *)infoFromALAsset:(ALAsset *)asset;



@end
