//
//  GCAsset.h
//
//  Created by Brandon Coston on 8/31/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCResource.h"
#import <AssetsLibrary/AssetsLibrary.h>

NSString * const GCAssetStatusChanged;
NSString * const GCAssetProgressChanged;
NSString * const GCAssetUploadComplete;

typedef enum {
    GCAssetStateNew = 0,
    GCAssetStateInitializingThumbnail,
    GCAssetStateInitializingThumbnailFailed,
    GCAssetStateGettingToken,
    GCAssetStateGettingTokenFailed,
    GCAssetStateUploadingToS3,
    GCAssetStateUploadingToS3Failed,
    GCAssetStateCompleting,
    GCAssetStateCompletingFailed,
    GCAssetStateFinished
} GCAssetStatus;

@interface GCAsset : GCResource

@property (nonatomic, retain) ALAsset *alAsset;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) GCAssetStatus status;

@property (nonatomic, retain) NSString *parentID;

- (NSDictionary *) uniqueRepresentation;
- (NSString *) uniqueURL;

- (NSString*)urlStringForImageWithWidth:(NSUInteger)width andHeight:(NSUInteger)height;

- (UIImage *)imageForWidth:(NSUInteger)width andHeight:(NSUInteger)height;

- (void)imageForWidth:(NSUInteger)width 
            andHeight:(NSUInteger)height 
inBackgroundWithCompletion:(void (^)(UIImage *))aResponseBlock;

- (void) upload;

- (GCResponse *) comments;
- (void) commentsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (GCResponse *) addComment:(NSString *) _comment;
- (void) addComment:(NSString *) _comment inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (BOOL) toggleHeart;
- (void) toggleHeartInBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (GCResponse *) heart;
- (void) heartInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock;

- (GCResponse *) unheart;
- (void) unheartInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolErrorBlock;

- (BOOL) isHearted;

- (GCResponse*) verify;

@end
