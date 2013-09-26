//
//  GCAccountAlbum.h
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/1/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCLinks;

@interface GCAccountAlbum : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) GCLinks *links;

@end
