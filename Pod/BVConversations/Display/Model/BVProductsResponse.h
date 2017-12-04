//
//  ProductsResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseConversationsResponse.h"
#import "BVProduct.h"
#import "BVResponse.h"
#import <Foundation/Foundation.h>
/*
 A response to a `BVProductDisplayPageRequest`. Contains one `BVProduct` in the
 `result` object.
 Contains other response information like the current index of pagination
 (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVProductsResponse : BVBaseConversationsResultResponse <BVProduct *>

@end
