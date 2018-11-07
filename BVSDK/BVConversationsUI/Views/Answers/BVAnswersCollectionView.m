//
//  BVAnswersCollectionView.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswersCollectionView.h"
#import "BVAnswer.h"
#import "BVAnswerCollectionViewCell.h"
#import "BVCommon.h"
#import "BVLogger+Private.h"
#import "BVMessageInterceptor.h"
#import "BVViewsHelper.h"

@interface BVAnswersCollectionView () <UICollectionViewDelegate,
                                       UICollectionViewDataSource> {
  BVMessageInterceptor *delegate_interceptor;
  BVMessageInterceptor *datasource_interceptor;
  BOOL hasSentScrollEvent;
  BOOL hasSentSeenEvent;
  NSMutableDictionary<NSString *, BVAnswer *> *cellToProductMap;
}
@end

@implementation BVAnswersCollectionView

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

  BVInViewEvent *inView = [[BVInViewEvent alloc]
         initWithProductId:@"none"
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsQuestionAnswer
           withContainerId:@"AnswersCollectionView"
      withAdditionalParams:nil];

  [BVPixel trackEvent:inView];
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
    hasSentScrollEvent = YES;

    BVFeatureUsedEvent *scrollEvent = [[BVFeatureUsedEvent alloc]
           initWithProductId:@"none"
                   withBrand:nil
             withProductType:BVPixelProductTypeConversationsQuestionAnswer
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
         initWithProductId:@"none"
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsQuestionAnswer
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

  if ([cell isKindOfClass:[BVAnswerCollectionViewCell class]]) {

    BVAnswerCollectionViewCell *bvCell = (BVAnswerCollectionViewCell *)cell;
    BVAnswer *answer = bvCell.answer;
    if (answer) {
      [cellToProductMap setObject:answer
                           forKey:[BVViewsHelper formatIndex:indexPath]];
    } else {
      // error, cell must have answer set
      NSString *message = @"BVAnswerCollectionViewCell has nil `answer` "
                          @"property. This must be set in "
                          @"`cellForItemAtIndexPath`.";
      BVLogError(message, BV_PRODUCT_CONVERSATIONS_UI);
      NSAssert(NO, message);
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
