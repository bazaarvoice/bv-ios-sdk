//
//  BVGenericConversationsResult.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVGenericConversationsResult+Private.h"

@implementation BVGenericConversationsResult

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse
                         includes:(nullable BVConversationsInclude *)includes {
  NSAssert(NO, @"initWithApiResponse method should be overridden");
  return [super init];
}

@end
