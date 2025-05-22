//
//  BVFeaturesRequest.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import "BVFeaturesRequest.h"
#import "BVCommaUtil.h"
#import "BVConversationsRequest+Private.h"
#import "BVStringKeyValuePair.h"

@interface BVFeaturesRequest ()

@property(nonnull, readonly) NSString *productId;
@property(nonnull, readonly) NSString *language;

@end

@implementation BVFeaturesRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId {
  return [self initWithProductId:productId language:@"en"];
}

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                   language:(nonnull NSString *)language {
    if ((self = [super init])) {
        _productId = [BVCommaUtil escape:productId];
        _language = language;
    }
  return self;
}


- (void)load:(nonnull void (^)(BVFeaturesResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure {
    [self loadProfile:self completion:success failure:failure];
}

- (void)
loadProfile:(nonnull BVConversationsRequest *)request
 completion:(nonnull void (^)(BVFeaturesResponse *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self loadContent:request
         completion:^(NSDictionary *__nonnull response) {
           BVFeaturesResponse *featuresResponse =
               [[BVFeaturesResponse alloc] initWithApiResponse:response];
           // invoke success callback on main thread
           dispatch_async(dispatch_get_main_queue(), ^{
             completion(featuresResponse);
           });

         }
            failure:failure];
}


- (nonnull NSString *)endpoint {
  return @"features.json";
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];


    [params
        addObject:[BVStringKeyValuePair pairWithKey:@"productId" value:self.productId]];

    [params
        addObject:[BVStringKeyValuePair pairWithKey:@"language" value:self.language]];

  return params;
}


@end
