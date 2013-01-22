//
//  GCUploader.h
//
//  Created by Achal Aggarwal on 09/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetChute.h"
#import "GCParcel.h"
#import "GCChute.h"
#import "GCAsset.h"

NSString * const GCUploaderProgressChanged;
NSString * const GCUploaderFinished;

@interface GCUploader : NSObject

@property (nonatomic, retain) NSMutableArray *queue;

@property (nonatomic, assign) CGFloat progress;

+ (GCUploader *)sharedUploader;

- (void) addParcel:(GCParcel *) _parcel;
- (void) removeParcel:(GCParcel *) _parcel;
- (int) queueAssetCount;
- (int) queueParcelCount;

- (void) backupQueueToUserDefaults;
- (void) loadQueueFromUserDefaults;

+ (void) uploadImage:(UIImage*)image toChute:(GCChute*)chute;
+ (void) uploadArrayOfImages:(NSArray*)images toChute:(GCChute*)chute;
+ (void) uploadAsset:(GCAsset*)asset toChute:(GCChute*)chute;
+ (void) uploadArrayOfAssets:(NSArray*)assets toChute:(GCChute*)chute;

@end
