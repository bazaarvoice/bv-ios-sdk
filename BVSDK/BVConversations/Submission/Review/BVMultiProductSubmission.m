//
//  BVMultiProductSubmission.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVMultiProductSubmission.h"
#import "BVMultiProductSubmissionResponse.h"
#import "BVMultiProductSubmissionErrorResponse.h"
#import "BVNetworkingManager.h"
#import "BVSDKConfiguration.h"
#import "BVStringKeyValuePair.h"
#import "BVSDKManager+Private.h"
#import "BVSubmission+Private.h"
#import "BVAnalyticsManager.h"

@interface BVMultiProductSubmission()
@property(nonnull, readwrite) NSString *userToken;
@property(nonnull, readwrite) NSArray <NSString*> *productIds;

@end
@implementation BVMultiProductSubmission

- (NSString *)conversationsKey {
    NSString *key =
    [BVSDKManager sharedManager].configuration.apiKeyConversations;
    NSAssert(key, @"Conversations key isn't configured");
    return key;
}

- (NSString *)localeIdentifier {
    NSString *identifier =
    [BVAnalyticsManager sharedManager].analyticsLocale.localeIdentifier;
    return identifier;
}

- (nonnull instancetype)initWithUserToken:(nonnull NSString *)userToken
                               productIds:(nonnull NSArray <NSString*> *)productIds {
    if ((self = [super init])) {
        self.userToken = userToken;
        self.productIds = productIds;
    }
    return self;
}

- (nonnull NSString *)endpoint {
    return @"submit/0.2alpha/multiproduct";
}

- (nonnull NSString *)commonEndpoint {
    return [BVSDKManager sharedManager].configuration.staging
    ? @"https://qa.api.bazaarvoice.com/data/"
    : @"https://api.bazaarvoice.com/data/";
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
    return [[BVMultiProductSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse: (nonnull NSDictionary *)raw {
    return [[BVMultiProductSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
    return nil;
}

- (nonnull NSURLRequest *)generateRequest {
    NSString *urlString = [NSString
                           stringWithFormat:@"%@%@", [self commonEndpoint], [self endpoint]];
    
    NSURLComponents *urlComponents = [NSURLComponents
                                      componentsWithString:urlString];
    
    NSArray<BVStringKeyValuePair *> *params = [self createParams];
    urlComponents.queryItems = [self getQueryItems:params];
    
    NSDictionary *parameters = [self createPostBody];
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlComponents.URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    
    [[BVLogger sharedLogger]
     verbose:[NSString stringWithFormat:@"POST: %@\n with BODY: %@", urlString,
              parameters]];
    
    return request;
}

- (nonnull NSMutableArray<BVStringKeyValuePair *> *)createParams {
    NSMutableArray<BVStringKeyValuePair *> *params = [NSMutableArray array];
    
    [params
     addObject:[BVStringKeyValuePair pairWithKey:@"siteName" value:@"main_site"]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Passkey"
                                                  value:[self conversationsKey]]];
    return params;
}

- (nonnull NSArray<NSURLQueryItem *> *)getQueryItems:
(NSArray<BVStringKeyValuePair *> *)params {
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    
    for (BVStringKeyValuePair *param in params) {
        if (param.value) {
            NSURLQueryItem *queryItem =
            [[NSURLQueryItem alloc] initWithName:param.key value:param.value];
            [queryItems addObject:queryItem];
        }
    }
    
    return queryItems;
}

- (nonnull NSDictionary *)createPostBody {
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"locale" : [self localeIdentifier],
                                                    @"productIds" : self.productIds,
                                                    @"userToken" : self.userToken
                                                    }];
    return parameters;
}

@end
