//
//  ProductsResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductsResponse.h"
#import "BVProduct.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"

@implementation BVProductsResponse

-(id)createResult:(NSDictionary *)raw includes:(BVConversationsInclude *)includes {
    return [[BVProduct alloc] initWithApiResponse:raw includes:includes];
}

@end
