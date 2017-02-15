//
//  BVCurationsCollectionViewCell.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "BVCurationsUICollectionView.h"

@class BVCurationsFeedItem;

typedef void (^BVCurationsLoadImageHandler)(NSString  * _Nonnull imageUrl, BVCurationsLoadImageCompletion _Nonnull completion);
typedef void (^BVCurationsImageIsCachedHandler)(NSString  * _Nonnull imageUrl, BVCurationsIsImageCachedCompletion _Nonnull completion);

@interface BVCurationsUICollectionViewCell : UICollectionViewCell

@property (nonatomic, copy, nonnull) BVCurationsLoadImageHandler loadImageHandler;
@property (nonatomic, copy, nonnull) BVCurationsImageIsCachedHandler loadImageIsCachedHandler;

@property (nonatomic, strong, nonnull) BVCurationsFeedItem *curationsFeedItem;
@property (nonatomic, assign, nonnull) id shouldLoadObject;
@property (nonatomic, strong, nonnull) NSString *shouldLoadKeypath;

@end
