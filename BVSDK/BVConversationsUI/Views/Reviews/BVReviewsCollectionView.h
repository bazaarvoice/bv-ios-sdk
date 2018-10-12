//
//  BVReviewsCollectionView.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVReviewsRequest.h"

/// A sub-classed UICollectionView for displaying BVReviewTableViewCells
@interface BVReviewsCollectionView : UICollectionView

/// Helper method to asynchronously load the Reviews for a given request. This
/// helper also ensures the proper analytic tracking is fired for reporting.
- (void)load:(nonnull BVReviewsRequest *)request
     success:(nonnull ReviewRequestCompletionHandler)success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
