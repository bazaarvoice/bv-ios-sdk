//
//  BVProductSentimentsRequest.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProductSentimentsRequest.h"
//#import "BVDisplayErrorResponse.h"
#import "BVLogger+Private.h"
#import "BVNetworkingManager.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVStringKeyValuePair.h"

@interface BVProductSentimentsRequest ()
@property(strong, nonatomic)
    NSMutableArray<BVStringKeyValuePair *> *customQueryParameters;
@end

@implementation BVProductSentimentsRequest

- (instancetype)init {
  return ((self = [super init]));
}

- (nonnull NSMutableArray<BVStringKeyValuePair *> *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [NSMutableArray array];

//  [params
//      addObject:[BVStringKeyValuePair pairWithKey:@"apiversion" value:@"5.4"]];
//  [params addObject:[BVStringKeyValuePair pairWithKey:@"passkey"
//                                                value:[self getPassKey]]];
//  [params addObject:[BVStringKeyValuePair
//                        pairWithKey:@"_appId"
//                              value:[NSBundle mainBundle].bundleIdentifier]];
//  [params
//      addObject:[BVStringKeyValuePair
//                    pairWithKey:@"_appVersion"
//                          value:[BVDiagnosticHelpers releaseVersionNumber]]];
//  [params addObject:[BVStringKeyValuePair
//                        pairWithKey:@"_buildNumber"
//                              value:[BVDiagnosticHelpers buildVersionNumber]]];
//  [params addObject:[BVStringKeyValuePair pairWithKey:@"_bvIosSdkVersion"
//                                                value:BV_SDK_VERSION]];

  if (_customQueryParameters) {
    [params addObjectsFromArray:_customQueryParameters];
  }

  return params;
}

- (nonnull NSString *)endpoint {
  NSAssert(NO, @"endpoint must be overridden by subclass");
  return nil;
}

+ (nonnull NSString *)commonEndpoint {
  return [BVSDKManager sharedManager].configuration.staging
             ? @"https://stg.api.bazaarvoice.com/sentiment/v1/"
             : @"https://api.bazaarvoice.com/sentiment/v1/";
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

- (void)
loadContent:(nonnull BVProductSentimentsRequest *)request
 completion:(nonnull void (^)(NSDictionary *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  NSString *url = [NSString
      stringWithFormat:@"%@%@", [BVProductSentimentsRequest commonEndpoint],
                       [request endpoint]];
  NSURLComponents *urlComponents = [NSURLComponents componentsWithString:url];
    
  NSArray<BVStringKeyValuePair *> *parameters = [request createParams];
  urlComponents.queryItems = [self getQueryItems:parameters];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:urlComponents.URL];
    urlRequest.HTTPMethod = @"GET";
    [urlRequest setValue:[self getPassKey]
        forHTTPHeaderField:@"Authorization"];
    
  BVLogVerbose(([NSString stringWithFormat:@"GET: %@", urlRequest.URL]),
               BV_PRODUCT_CONVERSATIONS);

  NSURLSession *session = nil;
  id<BVURLSessionDelegate> sessionDelegate =
      [BVSDKManager sharedManager].urlSessionDelegate;
  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector(URLSessionForBVObject:)]) {
    session = [sessionDelegate URLSessionForBVObject:self];
  }

  session = session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSURLSessionDataTask *task =
      [session dataTaskWithRequest:urlRequest
                 completionHandler:^(NSData *__nullable data,
                                     NSURLResponse *__nullable response,
                                     NSError *__nullable error) {

                   [self processData:data
                            response:response
                               error:error
                          completion:completion
                             failure:failure];

                 }];

  // start the request
  [task resume];

  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector
                       (URLSessionTask:fromBVObject:withURLSession:)]) {
    [sessionDelegate URLSessionTask:task
                       fromBVObject:self
                     withURLSession:session];
  }
}

- (void)
processData:(nullable NSData *)data
   response:(nullable NSURLResponse *)response
      error:(nullable NSError *)error
 completion:(nonnull void (^)(NSDictionary *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
  NSInteger statusCode = [httpResponse statusCode];

  if (statusCode == 200) {
    @try {
      NSError *err;
      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:&err];
      if (json) {
          
//        BVDisplayErrorResponse *errorResponse =
//            [[BVDisplayErrorResponse alloc] initWithApiResponse:json];
//
//        BVLogVerbose(([NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json,
//                                                 (long)statusCode]),
//                     BV_PRODUCT_CONVERSATIONS);
//
//        if (errorResponse) {
//          [self sendErrors:[errorResponse toNSErrors] failureCallback:failure];
//        } else {
//          // invoke success callback on main thread
          dispatch_async(dispatch_get_main_queue(), ^{
            completion(json);
          });
//        }
      } else if (err) {
        [self sendError:err failureCallback:failure];
      } else {
        NSError *parsingError =
            [NSError errorWithDomain:BVErrDomain
                                code:BV_ERROR_PARSING_FAILED
                            userInfo:@{
                              NSLocalizedDescriptionKey :
                                  @"An unknown parsing error occurred."
                            }];
        [self sendError:parsingError failureCallback:failure];
      }

    } @catch (NSException *exception) {
      NSError *err =
          [NSError errorWithDomain:BVErrDomain
                              code:BV_ERROR_UNKNOWN
                          userInfo:@{
                            NSLocalizedDescriptionKey :
                                @"An unknown parsing error occurred."
                          }];
      [self sendError:err failureCallback:failure];
    }
  } else {
    NSString *message = [NSString
        stringWithFormat:@"HTTP response status code: %li with error: %@",
                         (long)statusCode, error.localizedDescription];
    NSError *enhancedError =
        [NSError errorWithDomain:BVErrDomain
                            code:BV_ERROR_NETWORK_FAILED
                        userInfo:@{NSLocalizedDescriptionKey : message}];
    [self sendError:enhancedError failureCallback:failure];
  }
}

- (nonnull NSError *)limitError:(NSInteger)limit {
  NSString *message = [NSString
      stringWithFormat:@"Invalid `limit` value: Parameter 'limit' has "
                       @"invalid value: %li - must be between 1 and 100.",
                       (long)limit];
  return [NSError errorWithDomain:BVErrDomain
                             code:BV_ERROR_INVALID_LIMIT
                         userInfo:@{NSLocalizedDescriptionKey : message}];
}

- (nonnull NSError *)tooManyProductsError:
    (nonnull NSArray<NSString *> *)productIds {
  NSString *message = [NSString
      stringWithFormat:
          @"Too many productIds requested: %lu. Must be between 1 and 100.",
          (unsigned long)[productIds count]];
  return [NSError errorWithDomain:BVErrDomain
                             code:BV_ERROR_TOO_MANY_PRODUCTS
                         userInfo:@{NSLocalizedDescriptionKey : message}];
}

- (void)sendError:(nonnull NSError *)error
    failureCallback:(ProductSentimentsFailureHandler)failure {
  [self sendErrors:@[ error ] failureCallback:failure];
}

- (void)sendErrors:(nonnull NSArray<NSError *> *)errors
    failureCallback:(ProductSentimentsFailureHandler)failure {
  for (NSError *error in errors) {
    [[BVLogger sharedLogger] printError:error];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    failure(errors);
  });
}

- (nonnull NSString *)getPassKey {
  return [BVSDKManager sharedManager].configuration.apiKeyProductSentiments;
}

@end
