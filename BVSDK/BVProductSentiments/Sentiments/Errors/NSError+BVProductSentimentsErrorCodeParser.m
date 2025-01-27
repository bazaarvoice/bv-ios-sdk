//
//  NSError+BVProductSentimentsErrorCodeParser.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVFieldError.h"
#import "NSError+BVProductSentimentsErrorCodeParser.h"

@implementation NSError (BVErrorCodeParser)

- (BVProductSentimentsErrorCode)bvProductSentimentsErrorCode {
  NSString *code = [self userInfo][BVFieldErrorCode];
  if (!code) {
    return BVProductSentimentsErrorCodeUnknown;
  }
  if ([code isEqualToString:@"204"]) {
    return BVProductSentimentsErrorCodeNoContent;
  }
  if ([code isEqualToString:@"400"]) {
    return BVProductSentimentsErrorCodeBadRequest;
  }
  if ([code isEqualToString:@"403"]) {
    return BVProductSentimentsErrorCodeAccessDenied;
  }
  if ([code isEqualToString:@"429"]) {
    return BVProductSentimentsErrorCodeRequestLimitReached;
  }
  return BVProductSentimentsErrorCodeUnknown;
}

@end
