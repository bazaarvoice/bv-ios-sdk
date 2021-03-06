//
//  BVProductRecommendationsContainer.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVProductRecommendationsContainer.h"
#import "BVMessageInterceptor.h"
#import "BVRecommendations.h"

@interface BVProductRecommendationsContainer () {
  BOOL hasSentRenderedEvent;
  BOOL hasSentSeenEvent;
}
@end

@implementation BVProductRecommendationsContainer

- (void)loadRequest:(BVRecommendationsRequest *)request
    completionHandler:(recommendationsCompletionHandler)completionHandler
         errorHandler:(recommendationsErrorHandler)errorHandler {
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:completionHandler
           errorHandler:errorHandler];

  [BVRecsAnalyticsHelper
      queueEmbeddedRecommendationsPageViewEvent:request
                                       pageType:[self class]
                                 withWidgetType:RecommendationsCarousel];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  if (!newSuperview || hasSentRenderedEvent) {
    return;
  }

  hasSentRenderedEvent = YES;

  [BVRecsAnalyticsHelper
      queueAnalyticsEventForRecommendationsOnPage:RecommendationsCustom];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
  if (!newWindow || hasSentSeenEvent) {
    return;
  }

  hasSentSeenEvent = YES;
}

// helper

+ (NSString *)formatIndex:(NSIndexPath *)indexPath {
  return [NSString stringWithFormat:@"%li:%li", (long)indexPath.section,
                                    (long)indexPath.row];
}

@end

@interface BVProductRecommendationsTableView () <UITableViewDelegate,
                                                 UITableViewDataSource> {
  BVMessageInterceptor *delegate_interceptor;
  BVMessageInterceptor *datasource_interceptor;
  BOOL hasSentScrollEvent;
  BOOL hasSentRenderedEvent;
  BOOL hasSentSeenEvent;
  NSMutableDictionary *cellToProductMap;
}

@end

@implementation BVProductRecommendationsTableView

- (void)loadRequest:(BVRecommendationsRequest *)request
    completionHandler:(recommendationsCompletionHandler)completionHandler
         errorHandler:(recommendationsErrorHandler)errorHandler {
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:completionHandler
           errorHandler:errorHandler];

  [BVRecsAnalyticsHelper
      queueEmbeddedRecommendationsPageViewEvent:request
                                       pageType:[self class]
                                 withWidgetType:RecommendationsCarousel];
}

- (id)init {
  if ((self = [super init])) {
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  if ((self = [super initWithFrame:frame style:style])) {
    [self setup];
  }
  return self;
}

- (void)setup {
  cellToProductMap = [NSMutableDictionary dictionary];
  delegate_interceptor = [[BVMessageInterceptor alloc] initWithMiddleman:self];
  [super setDelegate:(id)delegate_interceptor];
  datasource_interceptor =
      [[BVMessageInterceptor alloc] initWithMiddleman:self];
  [super setDataSource:(id)datasource_interceptor];
}

- (void)setDelegate:(id<UITableViewDelegate>)newDelegate {
  [super setDelegate:nil];
  [delegate_interceptor setReceiver:newDelegate];
  [super setDelegate:(id)delegate_interceptor];
}

- (void)setDataSource:(id<UITableViewDataSource>)newDataSource {
  [super setDataSource:nil];
  [datasource_interceptor setReceiver:newDataSource];
  [super setDataSource:(id)datasource_interceptor];
}

- (void)dealloc {
  delegate_interceptor = nil;
  datasource_interceptor = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  if (!newSuperview || hasSentRenderedEvent) {
    return;
  }

  hasSentRenderedEvent = YES;

  [BVRecsAnalyticsHelper
      queueAnalyticsEventForRecommendationsOnPage:RecommendationsTableView];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
  if (!newWindow || hasSentSeenEvent) {
    return;
  }

  hasSentSeenEvent = YES;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [delegate_interceptor.receiver scrollViewWillBeginDragging:scrollView];
  }

  if (!hasSentScrollEvent) {
    hasSentScrollEvent = YES;
    [BVRecsAnalyticsHelper
        queueAnalyticsEventForWidgetScroll:RecommendationsTableView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [delegate_interceptor.receiver scrollViewDidEndDecelerating:scrollView];
  }

  [BVRecsAnalyticsHelper
      queueAnalyticsEventForWidgetScroll:RecommendationsTableView];
}

#pragma mark UITableViewDelegate

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath
                    animated:(BOOL)animated
              scrollPosition:(UITableViewScrollPosition)scrollPosition {
  [super selectRowAtIndexPath:indexPath
                     animated:animated
               scrollPosition:scrollPosition];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [delegate_interceptor.receiver tableView:tableView
                     didSelectRowAtIndexPath:indexPath];
  }

  BVRecommendedProduct *product = [cellToProductMap
      objectForKey:[BVProductRecommendationsContainer formatIndex:indexPath]];
  if (product) {
    [product recordTap];
  }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [datasource_interceptor.receiver tableView:tableView
                                               cellForRowAtIndexPath:indexPath];

  if ([cell isKindOfClass:[BVRecommendationTableViewCell class]]) {
    BVRecommendationTableViewCell *bvCell =
        (BVRecommendationTableViewCell *)cell;
    BVRecommendedProduct *product = bvCell.bvRecommendedProduct;
    if (product) {
      [cellToProductMap
          setObject:product
             forKey:[BVProductRecommendationsContainer formatIndex:indexPath]];
    } else {
      // error, cell must have product set
      [NSException raise:BVErrDomain
                  format:@"BVRecommendationTableViewCell has nil `bvProduct` "
                         @"property. "
                         @"This must be set in `cellForItemAtIndexPath`."];
    }
  }

  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [datasource_interceptor.receiver tableView:tableView
                              numberOfRowsInSection:section];
}

@end

@interface BVProductRecommendationsCollectionView () <
    UICollectionViewDelegate, UICollectionViewDataSource> {
  BVMessageInterceptor *delegate_interceptor;
  BVMessageInterceptor *datasource_interceptor;
  BOOL hasSentScrollEvent;
  BOOL hasSentRenderedEvent;
  BOOL hasSentSeenEvent;
  NSMutableDictionary *cellToProductMap;
}

@end

@implementation BVProductRecommendationsCollectionView

- (void)loadRequest:(BVRecommendationsRequest *)request
    completionHandler:(recommendationsCompletionHandler)completionHandler
         errorHandler:(recommendationsErrorHandler)errorHandler {
  BVRecommendationsLoader *loader = [[BVRecommendationsLoader alloc] init];
  [loader loadRequest:request
      completionHandler:completionHandler
           errorHandler:errorHandler];

  [BVRecsAnalyticsHelper
      queueEmbeddedRecommendationsPageViewEvent:request
                                       pageType:[self class]
                                 withWidgetType:RecommendationsCarousel];
}

- (id)init {
  if ((self = [super init])) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
    collectionViewLayout:(UICollectionViewLayout *)layout {
  if ((self = [super initWithFrame:frame collectionViewLayout:layout])) {
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self setup];
  }
  return self;
}

- (void)setup {
  cellToProductMap = [NSMutableDictionary dictionary];
  delegate_interceptor = [[BVMessageInterceptor alloc] initWithMiddleman:self];
  [super setDelegate:(id)delegate_interceptor];
  datasource_interceptor =
      [[BVMessageInterceptor alloc] initWithMiddleman:self];
  [super setDataSource:(id)datasource_interceptor];
}

- (void)setDataSource:(id<UICollectionViewDataSource>)newDataSource {
  [super setDataSource:nil];
  [datasource_interceptor setReceiver:newDataSource];
  [super setDataSource:(id)datasource_interceptor];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)newDelegate {
  [super setDelegate:nil];
  [delegate_interceptor setReceiver:newDelegate];
  [super setDelegate:(id)delegate_interceptor];
}

- (void)dealloc {
  delegate_interceptor = nil;
  datasource_interceptor = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  if (!newSuperview || hasSentRenderedEvent) {
    return;
  }

  hasSentRenderedEvent = YES;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
  if (!newWindow || hasSentSeenEvent) {
    return;
  }

  hasSentSeenEvent = YES;

  [BVRecsAnalyticsHelper
      queueAnalyticsEventForRecommendationsOnPage:RecommendationsCarousel];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [delegate_interceptor.receiver scrollViewWillBeginDragging:scrollView];
  }

  if (!hasSentScrollEvent) {
    hasSentScrollEvent = YES;
    [BVRecsAnalyticsHelper
        queueAnalyticsEventForWidgetScroll:RecommendationsCarousel];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [delegate_interceptor.receiver scrollViewDidEndDecelerating:scrollView];
  }

  [BVRecsAnalyticsHelper
      queueAnalyticsEventForWidgetScroll:RecommendationsCarousel];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([delegate_interceptor.receiver
          respondsToSelector:@selector
          (collectionView:didSelectItemAtIndexPath:)]) {
    [delegate_interceptor.receiver collectionView:collectionView
                         didSelectItemAtIndexPath:indexPath];
  }

  BVRecommendedProduct *product = [cellToProductMap
      objectForKey:[BVProductRecommendationsContainer formatIndex:indexPath]];
  if (product) {
    [product recordTap];
  }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell =
      [datasource_interceptor.receiver collectionView:collectionView
                               cellForItemAtIndexPath:indexPath];

  if ([cell isKindOfClass:[BVRecommendationCollectionViewCell class]]) {
    BVRecommendationCollectionViewCell *bvCell =
        (BVRecommendationCollectionViewCell *)cell;
    BVRecommendedProduct *product = bvCell.bvRecommendedProduct;
    if (product) {
      [cellToProductMap
          setObject:product
             forKey:[BVProductRecommendationsContainer formatIndex:indexPath]];
    } else {
      // error, cell must have product set
      [NSException raise:BVErrDomain
                  format:@"BVRecommendationCollectionViewCell has nil "
                         @"`bvRecommendedProduct` property. This must be set "
                         @"in `cellForItemAtIndexPath`."];
    }
  }

  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [datasource_interceptor.receiver collectionView:collectionView
                                  numberOfItemsInSection:section];
}

@end
