//
//  BVInitiateSubmitRequest.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVInitiateSubmitRequest.h"
#import "BVInitiateSubmitResponse.h"
#import "BVInitiateSubmitErrorResponse.h"
#import "BVNetworkingManager.h"
#import "BVFeatureUsedEvent.h"
#import "BVSDKConfiguration.h"
#import "BVStringKeyValuePair.h"
#import "BVSDKManager+Private.h"
#import "BVSubmission+Private.h"
#import "BVLogger+Private.h"
#import "BVAnalyticsManager.h"

@interface BVInitiateSubmitRequest()
@property(nonnull, readwrite) NSArray <NSString*> *productIds;
@end

@implementation BVInitiateSubmitRequest

- (nonnull NSString *)endpoint {
    return @"initiateSubmit.json";
}

- (nonnull instancetype)initWithProductIds:(nonnull NSArray <NSString*> *)productIds {
    if ((self = [super init])) {
        self.productIds = productIds;
        self.extendedResponse = NO;
    }
    return self;
}

- (nonnull NSURLRequest *)generateRequest {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [BVSubmission commonEndpoint], [self endpoint]];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlString];
    urlComponents.queryItems = [self getQueryItems];;
    NSData *postBody = [self createPostBody];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlComponents.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    
    BVLogVerbose(([NSString stringWithFormat:@"POST: %@\n with BODY: %@", urlString,
                   postBody]),
                 BV_PRODUCT_DREAMCATCHER);

    
    return request;
}

- (nonnull NSArray<NSURLQueryItem *> *)getQueryItems {
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"Passkey" value:[self conversationsKey]]];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"apiversion" value:@"5.4"]];    
    if (self.extendedResponse == YES) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"extended" value:nil]];
    }
    
    return queryItems;
}

- (nonnull NSData *)createPostBody {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"productIds" : self.productIds
                                                    }];
    parameters[@"locale"] = self.locale;
    parameters[@"userToken"] = self.userToken;
    parameters[@"userId"] = self.userId;
    parameters[@"deviceFingerprint"] = self.fingerPrint;
    parameters[@"campaignId"] = self.campaignId;
    
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    return postBody;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
    return [[BVInitiateSubmitResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse: (nonnull NSDictionary *)raw {
    return [[BVInitiateSubmitErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
    return [[BVFeatureUsedEvent alloc]
            initWithProductId:self.productIds.firstObject
            withBrand:nil
            withProductType:BVPixelProductTypeProgressiveSubmission
            withEventName:BVPixelFeatureUsedEventNameInView
            withAdditionalParams:nil];
}

@end
