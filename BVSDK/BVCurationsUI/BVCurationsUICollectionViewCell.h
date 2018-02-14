//
//  BVCurationsCollectionViewCell.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsUICollectionView.h"
#import <UIKit/UIKit.h>

@class BVCurationsFeedItem;

typedef void (^BVCurationsLoadImageHandler)(
    NSString *__nonnull imageUrl,
    BVCurationsLoadImageCompletion __nonnull completion);
typedef void (^BVCurationsImageIsCachedHandler)(
    NSString *__nonnull imageUrl,
    BVCurationsIsImageCachedCompletion __nonnull completion);

@interface BVCurationsUICollectionViewCell : UICollectionViewCell

@property(nonatomic, copy, nonnull)
    BVCurationsLoadImageHandler loadImageHandler;
@property(nonatomic, copy, nonnull)
    BVCurationsImageIsCachedHandler loadImageIsCachedHandler;

@property(nonatomic, strong, nonnull) BVCurationsFeedItem *curationsFeedItem;
@property(nonatomic, assign, nonnull) id shouldLoadObject;
@property(nonatomic, strong, nonnull) NSString *shouldLoadKeypath;

@end
