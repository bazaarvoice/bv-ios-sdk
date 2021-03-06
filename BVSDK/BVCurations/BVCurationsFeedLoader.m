//
//  BVCurationsFeedLoader.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsFeedLoader.h"
#import "BVCurationsFeedItem.h"
#import "BVLogger+Private.h"
#import "BVNetworkingManager.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"

@interface BVCurationsFeedLoader ()
@end

@implementation BVCurationsFeedLoader

- (instancetype)init {
  return ((self = [super init]));
}

- (NSString *)urlRootCurations {
  return [BVSDKManager sharedManager].configuration.staging
             ? @"https://stg.api.bazaarvoice.com"
             : @"https://api.bazaarvoice.com";
}

- (void)loadFeedWithRequest:(BVCurationsFeedRequest *)feedRequest
          completionHandler:(feedRequestCompletionHandler)completionHandler
                withFailure:(feedRequestErrorHandler)failureHandler;
{

  // check if apiKey is valid before loading any data. Will fail in debug only.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
  NSString *apiKey = [BVSDKManager sharedManager].configuration.apiKeyCurations;
  NSAssert(apiKey && 0 < apiKey.length,
           @"apiKeyCurations must be set on BVSDKManager before "
           @"using the Curations SDK.");
#pragma clang diagnostic pop
  NSString *endPoint = [NSString
      stringWithFormat:@"%@/curations/content/get", [self urlRootCurations]];

  NSURLComponents *components = [NSURLComponents componentsWithString:endPoint];

  NSArray *queryItems = [feedRequest createQueryItems];

  components.queryItems = queryItems;
  NSURL *url = components.URL;

  BVLogVerbose(([NSString stringWithFormat:@"GET: %@", url]),
               BV_PRODUCT_CURATIONS);

  NSURLSession *session = nil;
  id<BVURLSessionDelegate> sessionDelegate =
      [BVSDKManager sharedManager].urlSessionDelegate;
  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector(URLSessionForBVObject:)]) {
    session = [sessionDelegate URLSessionForBVObject:self];
  }

  session = session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSURLSessionDataTask *downloadTask = [session
        dataTaskWithURL:url
      completionHandler:^(NSData *data, NSURLResponse *response,
                          NSError *error) {

        NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;

        if ((!error && urlResp.statusCode < 300) && data) {

          NSError *errorJSON;
          NSDictionary *responseDict =
              [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&errorJSON];

          if (!errorJSON) {

            BVLogVerbose(
                ([NSString stringWithFormat:@"RESPONSE: %@", responseDict]),
                BV_PRODUCT_CURATIONS);

            // check response body status code first. Curations API will return
            // a 200 response on failures, but put the HTTP status in the "code"
            // value.
            NSInteger status = 200;

            if ([responseDict objectForKey:@"code"]) {
              status = [[responseDict objectForKey:@"code"] integerValue];
            }

            if (status < 300) {

              NSDictionary *updates = [responseDict objectForKey:@"updates"];
              NSMutableArray *feedItemsArray = [NSMutableArray array];
              NSMutableDictionary *referencedProdcts =
                  [NSMutableDictionary dictionary];

              // Check and see if product data is present
              NSDictionary *productData =
                  [responseDict objectForKey:@"productData"];

              if (productData) {

                for (NSString *key in productData.allKeys) {

                  NSDictionary *dictToParse = [productData objectForKey:key];

                  BVCurationsProductDetail *prod =
                      [[BVCurationsProductDetail alloc] initWithDict:dictToParse
                                                             withKey:key];

                  [referencedProdcts setObject:prod forKey:key];
                }
              }

              for (NSDictionary *update in updates) {
                BVCurationsFeedItem *feedItem =
                    [self getFeedItem:update
                        withReferencedProducts:referencedProdcts
                                withExternalId:feedRequest.externalId];

                if (feedItem) {
                  [feedItemsArray addObject:feedItem];
                }
              }

              dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(feedItemsArray);
              });

            } else {

              // status indicates failure....
              NSString *reason = @"Unknown failure.";
              if ([responseDict objectForKey:@"reason"]) {
                reason = [responseDict objectForKey:@"reason"];
              }
              NSDictionary *userInfo = @{NSLocalizedDescriptionKey : reason};
              NSError *err = [NSError errorWithDomain:BVErrDomain
                                                 code:status
                                             userInfo:userInfo];

              dispatch_async(dispatch_get_main_queue(), ^{
                failureHandler(err);
              });
            }

          } else {
            // serialization error
            dispatch_async(dispatch_get_main_queue(), ^{
              failureHandler(errorJSON);
            });
            return;
          }

        } else {

          // request error
          if (error) {

            dispatch_async(dispatch_get_main_queue(), ^{
              failureHandler(error);
            });
            return;

          } else {

            NSDictionary *userInfo =
                @{NSLocalizedDescriptionKey : urlResp.description};
            NSError *err = [NSError errorWithDomain:BVErrDomain
                                               code:urlResp.statusCode
                                           userInfo:userInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
              failureHandler(err);
            });
            return;
          }
        }

      }];

  [downloadTask resume];

  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector
                       (URLSessionTask:fromBVObject:withURLSession:)]) {
    [sessionDelegate URLSessionTask:downloadTask
                       fromBVObject:self
                     withURLSession:session];
  }
}

- (BVCurationsFeedItem *)getFeedItem:(NSDictionary *)update
              withReferencedProducts:(NSDictionary *)referencedProducts
                      withExternalId:(NSString *)externalId {

  NSDictionary *data = [update objectForKey:@"data"];
  return [[BVCurationsFeedItem alloc] initWithDict:data
                            withReferencedProducts:referencedProducts
                                    withExternalId:externalId];
}

@end
