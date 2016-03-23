//
//  BVProductRecommendationsContainer.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "BVRecommendationsLoader.h"

/**
    Recommendations container views conform to this protocol to be able to load recommendations
    via the `loadRequest:completionHandler:errorHandler:` required method.
 */
@protocol BVRecommendationsContainerProtocol <NSObject>

@required

/** 
    Load product recommendations based on data fed in from `request`.

    @param request             The request parameters to load
    @param completionHandler   Completion handler which returns an array of `BVProduct` product recommendations
    @param errorHandler        Error handler which returns an `NSError` if the request has failed.

    @availability 3.3.0 and later
 */
- (void)loadRequest:(BVRecommendationsRequest*)request
  completionHandler:(recommendationsCompletionHandler)completionHandler
       errorHandler:(recommendationsErrorHandler)errorHandler;

@end


/**
    A collection view to show product recommendations in.
 
    This collection view should be used in combination with `BVRecommendationCollectionViewCell` cells.
 */
@interface BVProductRecommendationsCollectionView : UICollectionView <BVRecommendationsContainerProtocol>

@end


/**
    A table view to show product recommendations in.
 
    This table view should be used in combination with `BVRecommendationTableViewCell` cells.
 */
@interface BVProductRecommendationsTableView : UITableView <BVRecommendationsContainerProtocol>

@end


/**
    A container view to show one or more product recommendations in.
 
    Usually, product recommendations are shown in a scrollable collection view or table view.
    For this case, use `BVProductRecommendationsCollectionView` or `BVProductRecommendationsTableView`.
 
    This container is meant to hold static, non-scrolling product recommendations.
    You should create one or more `BVProductRecommendationView` views and add them to this container view.
 */
@interface BVProductRecommendationsContainer : UIView <BVRecommendationsContainerProtocol>

@end