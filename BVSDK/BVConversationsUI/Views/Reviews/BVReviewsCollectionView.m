//
//  BVReviewsCollectionView.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewsCollectionView.h"
#import "BVCommon.h"
#import "BVMessageInterceptor.h"
#import "BVReview.h"
#import "BVReviewCollectionViewCell.h"
#import "BVViewsHelper.h"

@interface BVReviewsCollectionView () <UICollectionViewDelegate,
                                       UICollectionViewDataSource> {
  BVMessageInterceptor *delegate_interceptor;
  BVMessageInterceptor *datasource_interceptor;
  bool hasSentScrollEvent;
  bool hasSentInViewEvent;
  bool hasEnteredView;
  NSMutableDictionary<NSString *, BVReview *> *cellToProductMap;
  NSString *productId;
}
@end

@implementation BVReviewsCollectionView

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
  datasource_interceptor =
      [[BVMessageInterceptor alloc] initWithMiddleman:self];
  [super setDelegate:(id)delegate_interceptor];
  [super setDataSource:(id)datasource_interceptor];
}

- (void)tryToSendInViewEvent {

  if (hasEnteredView && productId) {
    if (!hasSentInViewEvent) {
      hasSentInViewEvent = true;

      BVInViewEvent *inView = [[BVInViewEvent alloc]
             initWithProductId:productId
                     withBrand:nil
               withProductType:BVPixelProductTypeConversationsReviews
               withContainerId:@"ReviewsCollectionView"
          withAdditionalParams:nil];

      [BVPixel trackEvent:inView];
    }
  }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
  [super willMoveToWindow:newWindow];
  hasEnteredView = true;

  [self tryToSendInViewEvent];
}

- (void)load:(nonnull BVReviewsRequest *)request
     success:(nonnull ReviewRequestCompletionHandler)success
     failure:(nonnull ConversationsFailureHandler)failure {

  productId = request.productId;
  [self tryToSendInViewEvent];

  [request load:success failure:failure];
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

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
    [delegate_interceptor.receiver scrollViewWillBeginDragging:scrollView];
  }

  if (!hasSentScrollEvent) {
    hasSentScrollEvent = true;

    BVFeatureUsedEvent *scrollEvent = [[BVFeatureUsedEvent alloc]
           initWithProductId:productId
                   withBrand:nil
             withProductType:BVPixelProductTypeConversationsReviews
               withEventName:BVPixelFeatureUsedEventNameScrolled
        withAdditionalParams:nil];

    [BVPixel trackEvent:scrollEvent];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
    [delegate_interceptor.receiver scrollViewDidEndDecelerating:scrollView];
  }

  BVFeatureUsedEvent *scrollEvent = [[BVFeatureUsedEvent alloc]
         initWithProductId:productId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNameScrolled
      withAdditionalParams:nil];

  [BVPixel trackEvent:scrollEvent];
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
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  UICollectionViewCell *cell =
      [datasource_interceptor.receiver collectionView:collectionView
                               cellForItemAtIndexPath:indexPath];

  if ([cell isKindOfClass:[BVReviewCollectionViewCell class]]) {

    BVReviewCollectionViewCell *bvCell = (BVReviewCollectionViewCell *)cell;
    BVReview *review = bvCell.review;
    if (review) {
      [cellToProductMap setObject:review
                           forKey:[BVViewsHelper formatIndex:indexPath]];
    } else {
      // error, cell must have review set
      NSString *message = @"BVReviewCollectionViewCell has nil `review` "
                          @"property. This must be set in "
                          @"`cellForItemAtIndexPath`.";
      [[BVLogger sharedLogger] error:message];
      NSAssert(false, message);
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
