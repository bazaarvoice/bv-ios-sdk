//
//  BVMatchedTokensSubmission.m
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

#import "BVMatchedTokensSubmission.h"
#import "BVMatchedTokensSubmissionErrorResponse.h"
#import "BVMatchedTokensSubmissionResponse.h"
#import "BVPixel.h"
#import "BVSubmission+Private.h"
#import "BVLogger+Private.h"

@implementation BVMatchedTokensSubmission

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                          withReviewText:(nonnull NSString *)reviewText {
  if ((self = [super init])) {
    self.productId = productId;
    self.reviewText = reviewText;
  }
  return self;
}

- (nonnull NSString *)endpoint {
  return @"matchedtokens";
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
    
    return queryItems;
}

- (nonnull NSData *)createPostBody {
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"productId" : self.productId,
                                                    @"reviewText" : self.reviewText
                                                    }];
    
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    return postBody;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVMatchedTokensSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
    return [[BVMatchedTokensSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (id<BVAnalyticEvent>)trackEvent {

  // Fire event now that we've confirmed that tokens were matched successfully.
  NSDictionary *additionalParams = @{
    @"detail1" : @"Matched Tokens"
  };

  BVFeatureUsedEvent *matchedTokensEvent =
      [[BVFeatureUsedEvent alloc] initWithProductId:self.productId
                                          withBrand:nil
                                    withProductType:BVPixelProductTypeConversationsReviews
                                      withEventName:BVPixelFeatureUsedEventNameContentCoach
                               withAdditionalParams:additionalParams];

  return matchedTokensEvent;
}

- (void)submit:(void (^__nonnull)(
          BVSubmissionResponse<BVSubmittedType *> *__nonnull))success
    failure:(nonnull ConversationsFailureHandler)failure {
    
  [super submit:success failure:failure];
}

@end
