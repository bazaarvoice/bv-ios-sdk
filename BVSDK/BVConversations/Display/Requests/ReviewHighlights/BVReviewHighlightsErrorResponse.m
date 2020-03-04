//
//  BVReviewHighlightsErrorResponse.m
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlightsErrorResponse.h"
#import "BVConversationsError.h"

@interface BVReviewHighlightsErrorResponse ()

@property(nonnull) BVConversationsError *error;

@end


@implementation BVReviewHighlightsErrorResponse

- (nullable id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
    if ((self = [super init])) {
        
        if (![[apiResponse objectForKey:@"error"] isKindOfClass:[NSString class]]) {
            return nil;
        }
        
        BVConversationsError *conversationsError = [[BVConversationsError alloc] initWithApiResponse:@{@"Message": (NSString *)[apiResponse objectForKey:@"error"]}];
        
        self.error = conversationsError;
    }
    return self;
}

- (nonnull NSError *)toNSError {
    return [self.error toNSError];
}

@end
