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
#import "BVLogger+Private.h"
#import "BVNetworkingManager.h"

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
                
        BVReviewHighlightsResponse *reviewHighlightsResponse = [[BVReviewHighlightsResponse alloc] initWithApiResponse:response];
        
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
          success(reviewHighlightsResponse);
        });
        
        // TODO:- Add analytics call if required.
    }
              failure:failure];
}

- (void)
loadContent:(nonnull BVReviewHighlightsRequest *)request
 completion:(nonnull void (^)(NSDictionary *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
    
    NSString *url = [NSString
        stringWithFormat:@"%@%@", [BVReviewHighlightsRequest commonEndpoint],
                         [request endpoint]];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlComponents.URL];
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
          
          NSLog(@"JSON: %@", json);
          if (json) {
//              BVDisplayErrorResponse *errorResponse =
//              [[BVDisplayErrorResponse alloc] initWithApiResponse:json];
//
//              BVLogVerbose(([NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json,
//                             (long)statusCode]),
//                           BV_PRODUCT_CONVERSATIONS);
              
              // TODO:- Map API Error Response

              // invoke success callback on main thread
              dispatch_async(dispatch_get_main_queue(), ^{
                  completion(json);
              });
              
//              if (errorResponse) {
//
//                  // TODO:- Send API Resopnse Error
////                  [self sendErrors:[errorResponse toNSErrors] failureCallback:failure];
//              } else {
//                  // invoke success callback on main thread
//                  dispatch_async(dispatch_get_main_queue(), ^{
//                      completion(json);
//                  });
//              }
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

- (void)sendError:(nonnull NSError *)error
    failureCallback:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  [self sendErrors:@[ error ] failureCallback:failure];
}

- (void)sendErrors:(nonnull NSArray<NSError *> *)errors
    failureCallback:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure {
  for (NSError *error in errors) {
    [[BVLogger sharedLogger] printError:error];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    failure(errors);
  });
}

@end
