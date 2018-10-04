//
//  ConversationsErrorResponse.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDisplayErrorResponse.h"
#import "BVConversationsError.h"

@interface BVDisplayErrorResponse ()

@property(nonnull) NSArray<BVConversationsError *> *errors;

@end

@implementation BVDisplayErrorResponse

- (nullable id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    if (![[apiResponse objectForKey:@"Errors"]
            isKindOfClass:[NSArray<NSDictionary *> class]]) {
      return nil;
    }

    NSArray<NSDictionary *> *rawErrors =
        (NSArray<NSDictionary *> *)[apiResponse objectForKey:@"Errors"];

    NSMutableArray *errorsArrayBuilder = [NSMutableArray array];
    for (NSDictionary *rawError in rawErrors) {
      BVConversationsError *conversationsError =
          [[BVConversationsError alloc] initWithApiResponse:rawError];
      [errorsArrayBuilder addObject:conversationsError];
    }

    if (0 == errorsArrayBuilder.count) {
      return nil;
    }

    self.errors = errorsArrayBuilder;
  }
  return self;
}

- (nonnull NSArray<NSError *> *)toNSErrors {
  NSMutableArray *nsErrorsBuilder = [NSMutableArray array];

  for (BVConversationsError *conversationsError in self.errors) {
    NSError *nsError = [conversationsError toNSError];
    [nsErrorsBuilder addObject:nsError];
  }

  return nsErrorsBuilder;
}

@end
