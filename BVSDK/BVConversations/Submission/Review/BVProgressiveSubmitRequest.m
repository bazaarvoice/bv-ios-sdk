//
//  BVProgressiveSubmitRequest.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVProgressiveSubmitRequest.h"
#import "BVProgressiveSubmitResponse.h"
#import "BVProgressiveSubmitResponseData.h"
#import "BVNetworkingManager.h"
#import "BVSDKConfiguration.h"
#import "BVStringKeyValuePair.h"
#import "BVSubmission+Private.h"
#import "BVSDKManager+Private.h"
#import "BVLogger+Private.h"
#import "BVAnalyticsManager.h"
#import "BVProgressiveSubmitErrorResponse.h"


@interface BVProgressiveSubmitRequest()
@end

@implementation BVProgressiveSubmitRequest

- (nonnull NSString *)endpoint {
    return @"progressiveSubmit.json";
}

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId {
    if ((self = [super init])) {
        self.productId = productId;
        self.extendedResponse = NO;
        self.includeFields = NO;
        self.isPreview = NO;
    }
    return self;
}

- (nonnull NSURLRequest *)generateRequest {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [BVSubmission commonEndpoint], [self endpoint]];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlString];
    urlComponents.queryItems = [self createQueryItems];
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

- (nonnull NSArray<NSURLQueryItem *> *)createQueryItems {
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"Passkey" value:[self conversationsKey]]];
    [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"apiversion" value:@"5.4"]];
    
    if (self.extendedResponse == YES) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"extended" value:nil]];
    }
    if (self.includeFields == YES) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"fields" value:nil]];
    }
    if (self.isPreview == YES) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"preview" value:nil]];
    }
    
    return queryItems;
}

- (nonnull NSData *)createPostBody {
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"productId" : self.productId,
                                                    }];
    parameters[@"locale"] = self.locale;
    parameters[@"userToken"] = self.userToken;
    parameters[@"submissionSessionToken"] = self.submissionSessionToken;
    parameters[@"userId"] = self.userId;
    parameters[@"useremail"] = self.userEmail;
    parameters[@"submissionFields"] = self.submissionFields;
    parameters[@"deviceFingerprint"] = self.fingerPrint;
    parameters[@"campaignId"] = self.campaignId;
    
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    return postBody;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
    return [[BVProgressiveSubmitResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse: (nonnull NSDictionary *)raw {
    return [[BVProgressiveSubmitErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
    return [[BVFeatureUsedEvent alloc]
            initWithProductId:self.productId
            withBrand:nil
            withProductType:BVPixelProductTypeProgressiveSubmission
            withEventName:BVPixelFeatureUsedEventNameWriteReview
            withAdditionalParams:nil];
}

@end
