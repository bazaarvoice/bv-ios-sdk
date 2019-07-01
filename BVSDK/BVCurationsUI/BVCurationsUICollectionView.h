//
//  BVCurationsCollectionView.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class BVCurationsFeedItem;
typedef NS_ENUM(NSInteger, BVCurationsUILayout) {
  BVCurationsUILayoutGrid,
  BVCurationsUILayoutCarousel
};

@protocol BVCurationsUICollectionViewDelegate;

@interface BVCurationsUICollectionView : UICollectionView

@property(nonatomic, weak, nullable) id<BVCurationsUICollectionViewDelegate>
    curationsDelegate;

/**
 The groups to be included in the carousel
 Default is no groups, so no content
 */
@property(nonatomic, strong, nonnull) NSArray<NSString *> *groups;

/**
 Setting has_photo causes the feed to be filtered based on the presence or
 absence of a photo on the update. Set this to true to require a photo or
 false to require the absence of one.
 
 Note that setting one or more has_PhotoOrVideo, has_photo, or has_video
 parameters yields the intersection (not the union) of the selected filters.
 */
@property(strong, nonatomic) NSNumber * _Nullable hasPhoto;

/**
 Setting has_video causes the feed to be filtered based on the presence or
 absence of a video on the update. Set this to true to require a video or
 false to require the absence of one.
 
 Note that setting one or more has_PhotoOrVideo, has_photo, or has_video
 parameters yields the intersection (not the union) of the
 selected filters.
 */
@property(strong, nonatomic) NSNumber * _Nullable hasVideo;

/**
 Setting hasPhotoOrVideo causes the feed to be filtered based on the presence
 or absence of a photo or video on the update. Set this to true to require a
 video or video, or false to require the absence of one.
 
 Note that setting one or more has_PhotoOrVideo, has_photo, or has_video
 parameters yields the intersection (not the
 union) of the selected filters.
 */
@property(strong, nonatomic) NSNumber * _Nullable hasPhotoOrVideo;

/**
 Used to only show content that includes a particular product by ID
 Default is not to filter by product
 */
@property(nonatomic, strong, nonnull) NSString *productId;

/**
 */
@property(nonatomic, strong, readonly, nonnull)
    NSArray<BVCurationsFeedItem *> *feedItems;

/**
 Amount of items to request per infinite scroll batch
 Default is 10
 */
@property(nonatomic, assign) NSUInteger fetchSize;

/**
 Should more items load automatically as scrolled
 Default is YES
 */
@property(nonatomic, assign) BOOL infiniteScrollEnabled;

/**
 Defines the layout of content
 Defaults to BVCurationsUILayoutGrid
 */
@property(nonatomic, assign) BVCurationsUILayout bvCurationsUILayout;

/**
 Number of content items in each row
 when bvCurationsUILayout == BVCurationsUILayoutGrid
 Defaults to 2
 */
@property(nonatomic, assign) NSUInteger itemsPerRow;

/**
 Begins loading content
 Should be called only once after setting the properties the first time
 */
- (void)loadFeed;

@end

typedef void (^BVCurationsLoadImageCompletion)(UIImage *__nullable image,
                                               NSString *__nonnull imageUrl);
typedef void (^BVCurationsIsImageCachedCompletion)(
    BOOL isCached, NSString *__nonnull imageUrl);

@protocol BVCurationsUICollectionViewDelegate <NSObject>

@required
/**
 Used to handle image loading to allow for custom caching.

 @param imageUrl url that should be loaded
 @param completion Must be called with loaded image and url
 */
- (void)curationsLoadImage:(nonnull NSString *)imageUrl
                completion:(nonnull BVCurationsLoadImageCompletion)completion;

/**
 Used to let SDK know if image is cached to opitimize display.
 @param imageUrl url to verify if cached
 @param completion Must be called with BOOL isCached and url
 */
- (void)curationsImageIsCached:(nonnull NSString *)imageUrl
                    completion:
                        (nonnull BVCurationsIsImageCachedCompletion)completion;

@optional

/**
 Called when a user taps on an item

 @param feedItem the item the user tapped
 */
- (void)curationsDidSelectFeedItem:(nonnull BVCurationsFeedItem *)feedItem;

/**
 Called if fetching the feed failed
 @param error the error that occured
 */
- (void)curationsFailedToLoadFeed:(nonnull NSError *)error;
@end
