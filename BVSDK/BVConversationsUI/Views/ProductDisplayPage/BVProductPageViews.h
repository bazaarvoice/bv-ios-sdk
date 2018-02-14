//
//  BVProductPageViews.h
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProduct.h"
#import <UIKit/UIKit.h>

/// This sub-class of UIViewController can be sublcassed by clients who also
/// implement the BVProductDisplayPageRequest API.
@interface BVProductDisplayPageViewController : UIViewController

/// The product model on the product display page.
@property(nonatomic, strong) BVProduct *product;

@end

/// This sub-class of UITableViewController can be sublcassed by clients who
/// also implement the BVProductDisplayPageRequest API.
@interface BVProductDisplayPageTableViewController : UITableViewController

/// The product model on the product display page.
@property(nonatomic, strong) BVProduct *product;

@end

/// This sub-class of UICollectionViewController can be sublcassed by clients
/// who also implement the BVProductDisplayPageRequest API.
@interface BVProductDisplayPageCollectionViewController
    : UICollectionViewController

/// The product model on the product display page.
@property(nonatomic, strong) BVProduct *product;

@end
