//
//  ProductsResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDisplayResponse.h"
#import "BVProduct.h"

/*
 A response to a `BVProductDisplayPageRequest`. Contains one `BVProduct` in the
 `result` object.
 Contains other response information like the current index of pagination
 (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVProductsResponse : BVDisplayResultResponse <BVProduct *>

@end
