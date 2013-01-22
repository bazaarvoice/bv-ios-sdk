//
//  GCAssetUploader.h
//
//  Created by Achal Aggarwal on 08/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetChute.h"

@interface GCAssetUploader : NSObject

@property (nonatomic, retain) NSMutableSet *queue;

+ (GCAssetUploader *)sharedUploader;

- (void) addAsset:(GCAsset *) anAsset;
- (void) removeAsset:(GCAsset *) anAsset;

- (GCResponse *) createParcelWithAssets:(NSArray *) assets andChutes:(NSArray *) chutes;

@end
