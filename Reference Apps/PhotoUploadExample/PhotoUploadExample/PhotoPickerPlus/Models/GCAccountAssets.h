//
//  GCAccountAssets.h
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/1/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCAssetDimensions;

@interface GCAccountAssets : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *video_url;
@property (strong, nonatomic) GCAssetDimensions *dimensions;

@end
