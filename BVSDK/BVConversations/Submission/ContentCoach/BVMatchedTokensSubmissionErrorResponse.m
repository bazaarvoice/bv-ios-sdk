//
//  BVMatchedTokensSubmissionErrorResponse.m
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import "BVMatchedTokensSubmissionErrorResponse.h"
#import "BVMatchedTokens.h"

@implementation BVMatchedTokensSubmissionErrorResponse

- (instancetype)initWithApiResponse:(NSDictionary *)apiResponse {
    NSNumber *status = [apiResponse objectForKey:@"status"];
    if (status.intValue == 200) {
        return nil;
    }
    self.hasErrors = YES;
    NSDictionary *wrappedErrorDict = @{
        @"HasErrors": @YES,
        @"Errors": @[@{
            @"Code": [apiResponse objectForKey:@"status"] ?: @"",
            @"Message": [apiResponse objectForKey:@"detail"] ?: @"",
            @"Field": [apiResponse objectForKey:@"title"] ?: @""
        }]
    };
    if ((self = [super initWithApiResponse:wrappedErrorDict])) {
        self.errorResult = [[BVMatchedTokens alloc]
                       initWithApiResponse:apiResponse] ;
    }
    return self;
}
    
@end
