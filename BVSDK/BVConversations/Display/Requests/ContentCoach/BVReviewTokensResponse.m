//
//  BVReviewTokensResponse.m
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 
#import <Foundation/Foundation.h>
#import "BVReviewTokensResponse.h"
#import "BVConversationsInclude.h"
#import "BVDisplayResponse+Private.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"

@implementation BVReviewTokensResponse
- (id)createResult:(NSDictionary *)raw {
  return [[BVReviewTokens alloc] initWithApiResponse:raw];
}
@end
