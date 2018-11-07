

//
//  BVCurationsCollectionView.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsUICollectionView.h"
#import "BVCurationsFeedLoader.h"
#import "BVCurationsUICollectionViewCell.h"
#import "BVLogger+Private.h"

@interface BVCurationsUICollectionView () <
    UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property(nonatomic, strong) BVCurationsFeedLoader *curationsFeedLoader;
@property(nonatomic, strong)
    NSMutableArray<BVCurationsFeedItem *> *curationsFeedItems;
@property(nonatomic, strong) NSNumber *lastFetchedTimeStamp;
@property(nonatomic, assign) CGFloat totalHeight;
@property(nonatomic, assign) BOOL pendingUpdate;
@property(nonatomic, assign) BOOL allItemsFetched;
@property(nonatomic, strong) NSMutableSet *impressedItems;
@property(nonatomic, assign) CGFloat oldTimeStamp;
@property(nonatomic, assign) CGFloat oldBounds;
@property(nonatomic, strong) NSNumber *shouldRequestImageLoad;
@end

#define BVCurationCVCellID @"BVCurationsCollectionViewCell"
#define BVCurationsDesiredPadding 3
#define BVCurationsRowsOffScreenBeforeReload 2.5
#define BVCurationsVelocityThreshold 1000 // points per second

@implementation BVCurationsUICollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout {
  if ([super initWithFrame:frame collectionViewLayout:layout]) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if ([super initWithCoder:aDecoder]) {
    [self setup];
  }

  return self;
}

- (void)setup {
  _curationsFeedLoader = [[BVCurationsFeedLoader alloc] init];
  _curationsFeedItems = [NSMutableArray new];
  _impressedItems = [NSMutableSet new];
  _fetchSize = 10;
  _infiniteScrollEnabled = YES;
  _itemsPerRow = 2;
  _pendingUpdate = NO;
  _shouldRequestImageLoad = @YES;

  self.delegate = self;
  self.dataSource = self;
  [self registerClass:[BVCurationsUICollectionViewCell class]
      forCellWithReuseIdentifier:BVCurationCVCellID];
  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionViewLayout;
  layout.minimumLineSpacing = BVCurationsDesiredPadding;
  layout.minimumInteritemSpacing = BVCurationsDesiredPadding;
}

- (void)loadFeed {
  NSUInteger fetchSize = _fetchSize;

  /*
   If enabled we need to bump the initial fetch size to load just enough
   items to enable scrolling (need a little bit off screen)
   */
  if (_infiniteScrollEnabled) {
    CGFloat oneCellHeight = [self getOneCellDim:_itemsPerRow];
    NSUInteger totalExpected = _curationsFeedItems.count + fetchSize;
    CGFloat estimatedTotalHeight =
        oneCellHeight * ceil(totalExpected / _itemsPerRow);
    if (estimatedTotalHeight < self.bounds.size.height) {
      CGFloat diff = self.bounds.size.height - estimatedTotalHeight;
      NSUInteger numRowOffSet = ceil(diff / oneCellHeight);
      fetchSize += (numRowOffSet * _itemsPerRow);
    }
  }

  [self loadCurationsFeed:fetchSize lastFetched:_lastFetchedTimeStamp];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
  // placeholder may want to disallow
  super.delegate = delegate;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
  // placeholder may want to disallow
  super.dataSource = dataSource;
}

- (void)setBvCurationsUILayout:(BVCurationsUILayout)bvCurationsUILayout {
  _bvCurationsUILayout = bvCurationsUILayout;
  UICollectionViewFlowLayout *layout =
      (UICollectionViewFlowLayout *)self.collectionViewLayout;
  switch (_bvCurationsUILayout) {
  case BVCurationsUILayoutGrid:
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    break;
  case BVCurationsUILayoutCarousel:
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    break;
  default:
    break;
  }
  [self updateInfiniteScrollMeasurements:self.curationsFeedItems.count
                             itemsPerRow:self.itemsPerRow];

  [self reloadData];
}

- (NSArray<BVCurationsFeedItem *> *)feedItems {
  return [NSArray arrayWithArray:_curationsFeedItems];
}

- (void)loadCurationsFeed:(NSUInteger)limit
              lastFetched:(NSNumber *)lastFetchedTimeStamp {
  if (_pendingUpdate || _allItemsFetched) {
    return;
  }

  if (!_groups) {
    BVLogError(
        @"Groups not set on BVCurationsUICollectionView. Unable to load feed",
        BV_PRODUCT_CURATIONS_UI);
    return;
  }

  _pendingUpdate = YES;
  BVCurationsFeedRequest *req =
      [[BVCurationsFeedRequest alloc] initWithGroups:_groups];
  req.limit = limit;
  req.hasPhotoOrVideo = @YES;
  if (_lastFetchedTimeStamp) {
    req.before = _lastFetchedTimeStamp;
  }

  if (_productId && 0 < _productId.length) {
    req.externalId = _productId;
  }

  __weak typeof(self) weakSelf = self;
  [_curationsFeedLoader loadFeedWithRequest:req
      completionHandler:^(NSArray<BVCurationsFeedItem *> *items) {

        BVInViewEvent *inViewEvent = [[BVInViewEvent alloc]
               initWithProductId:req.externalId
                       withBrand:nil
                 withProductType:BVPixelProductTypeCurations
                 withContainerId:@"CurationsUICollectionView"
            withAdditionalParams:nil];

        [BVPixel trackEvent:inViewEvent];

        weakSelf.allItemsFetched = !items.count;
        weakSelf.pendingUpdate = NO;
        weakSelf.lastFetchedTimeStamp = items.lastObject.timestamp;
        [weakSelf.curationsFeedItems addObjectsFromArray:items];
        [weakSelf
            updateInfiniteScrollMeasurements:weakSelf.curationsFeedItems.count
                                 itemsPerRow:weakSelf.itemsPerRow];

        BOOL errorState = items.count > limit; // if for whatever reason the
                                               // api returns more items than
                                               // expected we'll just reload
        if (errorState) {
          [self reloadData];
        } else {
          NSMutableArray *indexPaths = [NSMutableArray new];
          NSUInteger inserted = (limit <= items.count) ? limit : items.count;
          for (NSUInteger i = 0; i < inserted; i++) {
            [indexPaths
                addObject:[NSIndexPath
                              indexPathForItem:weakSelf.curationsFeedItems
                                                   .count -
                                               1 - i
                                     inSection:0]];
          }

          [self insertItemsAtIndexPaths:indexPaths];
        }
      }
      withFailure:^(NSError *err) {
        weakSelf.pendingUpdate = NO;
        if ([self->_curationsDelegate
                respondsToSelector:@selector(curationsFailedToLoadFeed:)]) {
          [self->_curationsDelegate curationsFailedToLoadFeed:err];
        }
      }];
}

- (void)setItemsPerRow:(NSUInteger)itemsPerRow {
  _itemsPerRow = itemsPerRow;
  [self updateInfiniteScrollMeasurements:self.curationsFeedItems.count
                             itemsPerRow:self.itemsPerRow];
  [self loadFeed];
}

- (void)updateInfiniteScrollMeasurements:(NSInteger)itemCount
                             itemsPerRow:(NSInteger)itemsPerRow {
  _totalHeight = [self getTotalHeight:itemCount itemsPerRow:itemsPerRow];
}

- (CGFloat)getTotalHeight:(NSInteger)itemCount
              itemsPerRow:(NSInteger)itemsPerRow {
  CGFloat oneCellHeight = [self getOneCellDim:itemsPerRow];
  NSInteger numRows;
  if (_bvCurationsUILayout == BVCurationsUILayoutGrid) {
    numRows = ceil(_curationsFeedItems.count / _itemsPerRow);
  } else {
    numRows = _curationsFeedItems.count;
  }
  return oneCellHeight * numRows;
}

- (CGFloat)getOneCellDim:(NSInteger)itemsPerRow {
  CGFloat dim;
  if (_bvCurationsUILayout == BVCurationsUILayoutGrid) {
    dim = (self.frame.size.width / itemsPerRow) - BVCurationsDesiredPadding;
  } else {
    dim = self.frame.size.height - BVCurationsDesiredPadding;
  }
  return dim;
}

- (void)setFrame:(CGRect)frame {
  super.frame = frame;
  if (_itemsPerRow) {
    [self updateInfiniteScrollMeasurements:_curationsFeedItems.count
                               itemsPerRow:_itemsPerRow];
  }
}

#pragma mark : UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return _curationsFeedItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:
                                       (UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  BVCurationsUICollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:BVCurationCVCellID
                                                forIndexPath:indexPath];
  cell.shouldLoadObject = self;
  cell.shouldLoadKeypath = @"shouldRequestImageLoad";
  cell.loadImageHandler =
      ^(NSString *__nonnull imageUrl,
        BVCurationsLoadImageCompletion __nonnull completion) {
        [self->_curationsDelegate curationsLoadImage:imageUrl
                                          completion:completion];
      };
  cell.loadImageIsCachedHandler = ^(
      NSString *__nonnull imageUrl,
      BVCurationsIsImageCachedCompletion completion) {
    [self->_curationsDelegate
        curationsImageIsCached:imageUrl
                    completion:^(BOOL isCached, NSString *__nonnull imageUrl) {
                      completion(isCached, imageUrl);
                    }];
  };
  cell.curationsFeedItem = _curationsFeedItems[indexPath.item];

  if (![_impressedItems containsObject:cell.curationsFeedItem]) {
    [_impressedItems addObject:cell.curationsFeedItem];

    BVCurationsFeedItem *item = cell.curationsFeedItem;

    BVImpressionEvent *impression = [[BVImpressionEvent alloc]
           initWithProductId:item.externalId
               withContentId:item.contentId
              withCategoryId:nil
             withProductType:BVPixelProductTypeCurations
             withContentType:BVPixelImpressionContentCurationsFeedItem
                   withBrand:nil
        withAdditionalParams:@{@"syndicationSource" : item.sourceClient}];

    [BVPixel trackEvent:impression];
  }
  return cell;
}

#pragma mark : UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat oneCellDim = [self getOneCellDim:_itemsPerRow];
  return CGSizeMake(oneCellDim, oneCellDim);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  CGFloat padding = BVCurationsDesiredPadding / 2;
  return UIEdgeInsetsMake(padding, padding, padding, padding);
}

#pragma mark : UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [collectionView deselectItemAtIndexPath:indexPath animated:YES];
  BVCurationsFeedItem *item = _curationsFeedItems[indexPath.item];

  BVFeatureUsedEvent *tapEvent = [[BVFeatureUsedEvent alloc]
         initWithProductId:item.externalId
                 withBrand:nil
           withProductType:BVPixelProductTypeCurations
             withEventName:BVPixelFeatureUsedEventContentClick
      withAdditionalParams:nil];

  [BVPixel trackEvent:tapEvent];

  if ([_curationsDelegate
          respondsToSelector:@selector(curationsDidSelectFeedItem:)]) {
    [_curationsDelegate curationsDidSelectFeedItem:item];
  }
}

#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!_infiniteScrollEnabled || _allItemsFetched) {
    return;
  }

  CGFloat timestamp = [[NSDate date] timeIntervalSince1970];
  CGFloat newBounds = (_bvCurationsUILayout == BVCurationsUILayoutGrid)
                          ? scrollView.bounds.origin.y
                          : scrollView.bounds.origin.x;
  CGFloat boundsDiff = fabs(_oldBounds - newBounds);
  CGFloat timeDiff = timestamp - _oldTimeStamp;
  _oldTimeStamp = timestamp;
  _oldBounds = newBounds;
  CGFloat velocity = boundsDiff / timeDiff;

  if (velocity < BVCurationsVelocityThreshold) {
    [self attemptToTransitionToLoadImages];
  } else {
    _shouldRequestImageLoad = @NO;
  }

  CGFloat oneCellHeight = [self getOneCellDim:_itemsPerRow];
  CGFloat lowerBounds;
  if (_bvCurationsUILayout == BVCurationsUILayoutGrid) {
    lowerBounds = scrollView.bounds.origin.y + scrollView.bounds.size.height;
  } else {
    lowerBounds = scrollView.bounds.origin.x + scrollView.bounds.size.width;
  }

  CGFloat totalHeigthWithReloadOffest =
      (_totalHeight - (oneCellHeight * BVCurationsRowsOffScreenBeforeReload));
  if (lowerBounds > totalHeigthWithReloadOffest) {
    [self loadCurationsFeed:_fetchSize lastFetched:_lastFetchedTimeStamp];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self attemptToTransitionToLoadImages];

  BVFeatureUsedEvent *scrollEvent = [[BVFeatureUsedEvent alloc]
         initWithProductId:_productId
                 withBrand:nil
           withProductType:BVPixelProductTypeCurations
             withEventName:BVPixelFeatureUsedEventNameScrolled
      withAdditionalParams:nil];

  [BVPixel trackEvent:scrollEvent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
  [self attemptToTransitionToLoadImages];
}

- (void)attemptToTransitionToLoadImages {
  BOOL transition = !_shouldRequestImageLoad.boolValue;
  if (transition) {
    self.shouldRequestImageLoad = @YES;
  }
}
@end
