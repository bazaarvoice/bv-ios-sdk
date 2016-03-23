//
//  BVCurationsFeedCollectionView.h
//  Bazaarvoice SDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVCurationsFeedRequest.h"

NS_ASSUME_NONNULL_BEGIN


typedef void (^feedRequestCompletionHandler)(NSArray<BVCurationsFeedItem *> *);
typedef void (^feedRequestErrorHandler)(NSError*);


/// A UICollectionView to display curations feed items in. Use this class in combination with `BVCurationsCollectionViewCell` to display individual feed items.
@interface BVCurationsCollectionView : UICollectionView


/**
    Loads a curations feed with parameters provided by `feedRequest`
 
    @param feedRequest The parameters used to make the request.
    @param widgetId When presenting more than one BVCurationsCollectionView in a ViewController, provide unique names for each configuration type. This is used for analytics reporting to caluclate performance among different BVCurationsCollectionView configurations. If only providing one collection view, just set to nil.
    @param completionHandler The completion block fired on a successful API response. Called on main thread.
    @param failureHandler The completion block fired when the API fails. Details in the NSError object. Called on main thread.
 */
- (void)loadFeedWithRequest:(BVCurationsFeedRequest *)feedRequest
               withWidgetId:(NSString * _Nullable)widgetId
          completionHandler:(feedRequestCompletionHandler)completionHandler
                withFailure:(feedRequestErrorHandler)failureHandler;

@end

NS_ASSUME_NONNULL_END
