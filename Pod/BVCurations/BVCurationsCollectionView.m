//
//  BVCurationsFeedCollectionView.m
//  Bazaarvoice SDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVCurationsCollectionView.h"
#import "BVMessageInterceptor.h"
#import "BVCurationsCollectionViewCell.h"
#import "BVCurationsFeedItem.h"
#import "BVCurationsAnalyticsHelper.h"
#import "BVCurationsFeedLoader.h"
#import "BVSDK.h"

@interface BVCurationsCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    BVMessageInterceptor* delegate_interceptor;
    BVMessageInterceptor* datasource_interceptor;
    
    bool hasSentScrollEvent;
    bool hasSentSeenEvent;
    
    NSMutableDictionary* cellToProductMap;
    
    BVCurationsFeedRequest *params;
    
    // The unique widget identifier for this UICollectionView. A default of "MainGrid" is supplied if not set. In the event you display > 1 BVCurationsCollectionView on a single UIViewController, the widgetId should be set as "SecondGrid", "ThridGrid", and so on.
    NSString *widgetIdentifer;
}

@end

@implementation BVCurationsCollectionView


-(id)init {
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self){
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

- (void)loadFeedWithRequest:(BVCurationsFeedRequest *)feedRequest
               withWidgetId:(NSString * _Nullable)widgetId
          completionHandler:(feedRequestCompletionHandler)completionHandler
                withFailure:(feedRequestErrorHandler)failureHandler;{
    
    params = feedRequest;
    
    if (widgetId){
        widgetIdentifer = widgetId;
    } else {
        widgetIdentifer = @"MainGrid";
    }
    
    BVCurationsFeedLoader *apiRequest = [[BVCurationsFeedLoader alloc] init];
    [apiRequest loadFeedWithRequest:params completionHandler:^(NSArray *feedItems) {
        // completion
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionHandler(feedItems);
            
        });
        
        [BVCurationsAnalyticsHelper queueEmbeddedPageViewEventCurationsFeed:CurationsFeedCarousel withExternalId:params.externalId];
        
    } withFailure:^(NSError *error) {
        // error
        failureHandler(error);
    }];
}

-(void)setup {
    cellToProductMap = [NSMutableDictionary dictionary];
    delegate_interceptor = [[BVMessageInterceptor alloc] initWithMiddleman:self];
    [super setDelegate:(id)delegate_interceptor];
    datasource_interceptor = [[BVMessageInterceptor alloc] initWithMiddleman:self];
    [super setDataSource:(id)datasource_interceptor];
}

-(void)setDataSource:(id<UICollectionViewDataSource>)newDataSource {
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


-(void)willMoveToWindow:(UIWindow *)newWindow {
    
    if (newWindow == nil || hasSentSeenEvent){
        return;
    }
    
    hasSentSeenEvent = true;
    
    // This container is now on screen
    [BVCurationsAnalyticsHelper queueUsedFeatureEventForContainerInView:CurationsFeedCarousel withExternalId:params.externalId withWidgetId:widgetIdentifer];
    
}

#pragma mark UIScrollViewDelegate


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        [delegate_interceptor.receiver scrollViewWillBeginDragging:scrollView];
    }
    
    
    if(!hasSentScrollEvent) {
        hasSentScrollEvent = true;
        [BVCurationsAnalyticsHelper queueUsedFeatureEventForWidgetScroll:CurationsFeedCarousel withExternalId:params.externalId];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [delegate_interceptor.receiver scrollViewDidEndDecelerating:scrollView];
    }
    
    [BVCurationsAnalyticsHelper queueUsedFeatureEventForWidgetScroll:CurationsFeedCarousel withExternalId:params.externalId];
 
}


+(NSString*)formatIndex:(NSIndexPath*)indexPath {
    return [NSString stringWithFormat:@"%li:%li", indexPath.section, indexPath.row];
}

#pragma mark UICollectionViewDelegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([delegate_interceptor.receiver respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [delegate_interceptor.receiver collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    BVCurationsFeedItem *feedItem = [cellToProductMap objectForKey:[BVCurationsCollectionView formatIndex:indexPath]];
    if (feedItem != nil){
        [feedItem recordTap];
    }
    
}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [datasource_interceptor.receiver collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if([cell isKindOfClass:[BVCurationsCollectionViewCell class]]) {
        
        BVCurationsCollectionViewCell* bvCell = (BVCurationsCollectionViewCell*)cell;
        BVCurationsFeedItem* item = bvCell.feedItem;
        if(item != nil){
            [cellToProductMap setObject:item forKey:[BVCurationsCollectionView formatIndex:indexPath]];
        }
        else {
            // error, cell must have product set
            [NSException raise:BVErrDomain format:@"BVCurationsCollectionViewCell has nil `feedItem` property. This must be set in `cellForItemAtIndexPath`."];
        }
        
    }
    
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [datasource_interceptor.receiver collectionView:collectionView numberOfItemsInSection:section];
}

@end
