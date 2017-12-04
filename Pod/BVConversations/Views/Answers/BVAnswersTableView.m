//
//  BVAnswersTableView.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswersTableView.h"
#import "BVAnswerTableViewCell.h"
#import "BVCore.h"
#import "BVMessageInterceptor.h"
#import "BVViewsHelper.h"

@interface BVAnswersTableView () <UITableViewDelegate, UITableViewDataSource> {
  BVMessageInterceptor *delegate_interceptor;
  BVMessageInterceptor *datasource_interceptor;
  bool hasSentScrollEvent;
  bool hasSentRenderedEvent;
  bool hasSentSeenEvent;
  NSMutableDictionary<NSString *, BVAnswer *> *cellToProductMap;
}
@end

@implementation BVAnswersTableView

- (id)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
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
           withContainerId:@"AnswersTableView"
      withAdditionalParams:nil];

  [BVPixel trackEvent:inView];
}

- (void)setDataSource:(id<UITableViewDataSource>)newDataSource {
  [super setDataSource:nil];
  [datasource_interceptor setReceiver:newDataSource];
  [super setDataSource:(id)datasource_interceptor];
}

- (void)setDelegate:(id<UITableViewDelegate>)newDelegate {
  [super setDelegate:nil];
  [delegate_interceptor setReceiver:newDelegate];
  [super setDelegate:(id)delegate_interceptor];
}

- (void)dealloc {
  delegate_interceptor = nil;
  datasource_interceptor = nil;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [datasource_interceptor.receiver tableView:tableView
                              numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *cell = [datasource_interceptor.receiver tableView:tableView
                                               cellForRowAtIndexPath:indexPath];

  if ([cell isKindOfClass:[BVAnswerTableViewCell class]]) {

    BVAnswerTableViewCell *answerCell = (BVAnswerTableViewCell *)cell;
    BVAnswer *answer = answerCell.answer;
    if (answer) {
      [cellToProductMap setObject:answer
                           forKey:[BVViewsHelper formatIndex:indexPath]];
    } else {
      // error, cell must have answer set
      NSString *message = @"BVAnswerTableViewCell has nil `answer` property. "
                          @"This must be set in `cellForItemAtIndexPath`.";
      [[BVLogger sharedLogger] error:message];
      NSAssert(false, message);
    }
  }

  return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if ([delegate_interceptor.receiver
          respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [delegate_interceptor.receiver tableView:tableView
                     didSelectRowAtIndexPath:indexPath];
  }
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

@end
