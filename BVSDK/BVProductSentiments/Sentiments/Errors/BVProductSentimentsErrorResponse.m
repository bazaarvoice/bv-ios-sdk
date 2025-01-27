//
//  BVProductSentimentsErrorResponse.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "BVProductSentimentsErrorResponse.h"
#import "BVNullHelper.h"
#import "BVProductSentimentsErrorCode.h"
#import "NSError+BVProductSentimentsErrorCodeParser.h"
//#import "BVConversationsError.h"

@interface BVProductSentimentsErrorResponse ()

@property(nonnull) NSArray<NSError *> *errors;

@end

@implementation BVProductSentimentsErrorResponse

- (nullable id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
      self.code = @"N/A";
      self.type = @"N/A";
      self.title = @"N/A";
      self.detail = @"N/A";
        
      
      SET_IF_NOT_NULL(self.code, apiResponse[@"code"])
      SET_IF_NOT_NULL(self.type, apiResponse[@"type"])
      SET_IF_NOT_NULL(self.title, apiResponse[@"title"])
      SET_IF_NOT_NULL(self.detail, apiResponse[@"detail"])

    if (![[apiResponse objectForKey:@"Errors"]
            isKindOfClass:[NSArray<NSDictionary *> class]]) {
      return nil;
    }

    NSArray<NSDictionary *> *rawErrors =
        (NSArray<NSDictionary *> *)[apiResponse objectForKey:@"Errors"];

    NSMutableArray *errorsArrayBuilder = [NSMutableArray array];
//    for (NSDictionary *rawError in rawErrors) {
//      BVConversationsError *conversationsError =
//          [[BVConversationsError alloc] initWithApiResponse:rawError];
//      [errorsArrayBuilder addObject:conversationsError];
//    }

    if (0 == errorsArrayBuilder.count) {
      return nil;
    }

    self.errors = errorsArrayBuilder;
  }
  return self;
}

- (nonnull NSArray<NSError *> *)toNSErrors {
  NSMutableArray *nsErrorsBuilder = [NSMutableArray array];

//    NSError *err = [[NSError alloc] bvProductSentimentsErrorCode: self.code];
//    
//    
//  for (BVConversationsError *conversationsError in self.errors) {
//    NSError *nsError = [conversationsError toNSError];
//    [nsErrorsBuilder addObject:nsError];
//  }
    

    

  return nsErrorsBuilder;
}

@end
