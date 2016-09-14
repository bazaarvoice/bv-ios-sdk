//
//  BVStoreReviewsTableView.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVViewsHelper.h"
#import "BVStoreReviewsRequest.h"

/// A sub-classed UITableView for displaying BVReviewTableViewCells, where review are from a parent BVStore.
@interface BVStoreReviewsTableView : UITableView

/// Helper method to asynchronously load the Reviews for a given request. This helper also ensures the proper analytic tracking is fired for reporting.
- (void)load:(nonnull BVStoreReviewsRequest*)request
     success:(nonnull StoreReviewRequestCompletionHandler)success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
