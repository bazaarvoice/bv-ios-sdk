//
//  BVReviewSummaryResponse.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewSummaryResponse.h"
#import "BVConversationsInclude.h"
#import "BVDisplayResponse+Private.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"

@implementation BVReviewSummaryResponse
- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVReviewSummary alloc] initWithApiResponse:raw includes:includes];
}
@end
