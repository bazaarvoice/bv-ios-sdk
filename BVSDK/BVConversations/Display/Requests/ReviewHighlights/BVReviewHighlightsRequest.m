//
//  BVReviewHighlightsRequest.m
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import "BVReviewHighlightsRequest.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVStringKeyValuePair.h"

@implementation BVReviewHighlightsRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId {
    
    if (self = [super init]) {
        _productId = productId;
    }
    return  self;
}

+ (nonnull NSString *)commonEndpoint {
  return [BVSDKManager sharedManager].configuration.staging
             ? @"https://rh-stg.nexus.bazaarvoice.com/"
             : @"https://rh.nexus.bazaarvoice.com/";
}

- (nonnull NSString *)getClientId {
    return [BVSDKManager sharedManager].configuration.clientId;
}

- (nonnull NSString *)endpoint {
    NSString *endpoint = [NSString stringWithFormat:@"highlights/v3/1/%@/%@", [self getClientId], self.productId];
    return endpoint;
}

- (nonnull NSMutableArray<BVStringKeyValuePair *> *)createParams {
    return nil;
}

- (void)load:(void (^)(BVReviewHighlightsResponse * _Nonnull))success failure:(ConversationsFailureHandler)failure {
    
    [self loadContent:self
           completion:^(NSDictionary * _Nonnull response) {
        
        NSLog(@"Response: %@", response);
        
    } failure:^(NSArray<NSError *> * _Nonnull errors) {
        
    }];
}


@end
