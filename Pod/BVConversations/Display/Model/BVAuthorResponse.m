//
//  BVAuthorResponse.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorResponse.h"
#import "BVNullHelper.h"
#import "BVConversationsInclude.h"

@implementation BVAuthorResponse
-(id)createResult:(NSDictionary *)raw includes:(BVConversationsInclude *)includes {
    return [[BVAuthor alloc] initWithApiResponse:raw includes:includes];
}
@end
