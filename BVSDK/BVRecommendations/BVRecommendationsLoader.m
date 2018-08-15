//
//  BVRecommendationsLoader.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>

#import "BVCommon.h"
#import "BVNetworkingManager.h"
#import "BVRecommendationsLoader+Private.h"
#import "BVRecommendationsRequest+Private.h"
#import "BVRecommendationsRequestOptionsUtil.h"
#import "BVRecsAnalyticsHelper.h"
#import "BVSDKConfiguration.h"
#import "BVShopperProfile.h"
#import "BVShopperProfileRequestCache.h"

@interface BVRecommendationsLoader ()
@end

@implementation BVRecommendationsLoader

+ (void)purgeRecommendationsCache {
  [[BVShopperProfileRequestCache sharedCache] removeAllCachedResponses];
}

- (instancetype)init {
  return ((self = [super init]));
}

- (void)loadRequest:(BVRecommendationsRequest *)request
    completionHandler:(recommendationsCompletionHandler)completionHandler
         errorHandler:(recommendationsErrorHandler)errorHandler {

  BVShopperProfileRequestCache *cache =
      [BVShopperProfileRequestCache sharedCache];

  NSURL *url = [self getURLForRequest:request];
  if (!url) {
    [self errorOnMainThread:[self invalidSDKError] handler:errorHandler];
    return;
  }

  [[BVLogger sharedLogger]
      verbose:[NSString stringWithFormat:@"GET: %@", url.absoluteString]];

  NSURLRequest *networkRequest = [NSURLRequest requestWithURL:url];

  NSCachedURLResponse *cachedResp =
      [cache cachedResponseForRequest:networkRequest];

  NSURLSession *session = nil;
  id<BVURLSessionDelegate> sessionDelegate =
      [BVSDKManager sharedManager].urlSessionDelegate;
  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector(URLSessionForBVObject:)]) {
    session = [sessionDelegate URLSessionForBVObject:self];
  }

  if (cachedResp) {
    NSDictionary *responseDict =
        [NSJSONSerialization JSONObjectWithData:cachedResp.data
                                        options:kNilOptions
                                          error:nil];

    BVShopperProfile *profile =
        [[BVShopperProfile alloc] initWithDictionary:responseDict];

    [cache printCacheSize];

    [[BVLogger sharedLogger]
        verbose:[NSString
                    stringWithFormat:@"CACHED RESPONSE: %@", responseDict]];

    [self completionOnMainThread:profile.recommendations
                         handler:completionHandler];

    return;
  }

  session = session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSURLSessionDataTask *task = [session
      dataTaskWithRequest:networkRequest
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *error) {

          // request error
          if (error) {
            [self errorOnMainThread:error handler:errorHandler];
            return;
          }

          NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;

          if (data && httpResp && httpResp.statusCode < 300) {

            NSError *errorJSON;
            NSDictionary *responseDict =
                [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&errorJSON];

            if (errorJSON) {
              // serialization error
              [self errorOnMainThread:errorJSON handler:errorHandler];
              return;
            }

            BVShopperProfile *profile =
                [[BVShopperProfile alloc] initWithDictionary:responseDict];

            [[BVLogger sharedLogger]
                verbose:[NSString stringWithFormat:@"RESPONSE: (%ld): %@",
                                                   (long)httpResp.statusCode,
                                                   responseDict]];

            // Successful response, save in cache
            NSCachedURLResponse *newCachedResp =
                [[NSCachedURLResponse alloc] initWithResponse:response
                                                         data:data];

            [cache storeCachedResponse:newCachedResp forRequest:networkRequest];

            // Success!
            [self completionOnMainThread:profile.recommendations
                                 handler:completionHandler];

            return;
          }

          /*
           * It *IS* possible to get back a nil response so we have to protect
           * against this. We just default to a 400 since it's probably likely
           * something amiss with the client if a nil response is returned,
           * e.g., weird timeout, memory pressure; malloc fails, etc.
           */
          NSString *errorDescription =
              httpResp.description ?: @"Unknown Client Error";
          NSInteger errorCode = httpResp ? httpResp.statusCode : 400;

          // unknown/uncaught error
          NSDictionary *userInfo =
              @{NSLocalizedDescriptionKey : errorDescription};
          NSError *err = [NSError errorWithDomain:BVErrDomain
                                             code:errorCode
                                         userInfo:userInfo];
          [self errorOnMainThread:err handler:errorHandler];
        }];

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
completionOnMainThread:(NSArray<BVRecommendedProduct *> *)recommendations
               handler:(recommendationsCompletionHandler)completionHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
    completionHandler(recommendations);
  });
}

- (void)errorOnMainThread:(NSError *)error
                  handler:(recommendationsErrorHandler)errorHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
    errorHandler(error);
  });
}

- (NSURL *)getURLForRequest:(BVRecommendationsRequest *)request {
  // check if SDK is properly configured
  // if not, hit the error handler
  if (![self isSDKValid]) {
    return nil;
  }

  BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
  NSString *client = sdkMgr.configuration.clientId;
  NSString *apiRoot = sdkMgr.urlRootShopperAdvertising;
  NSString *apiKey = sdkMgr.configuration.apiKeyShopperAdvertising;

  // check that `apiKeyShopperAdvertising` is valid. Will fail only in debug
  // mode.
  NSAssert(apiKey && 0 < apiKey.length,
           @"You must supply apiKeyShopperAdvertising in the "
           @"BVSDKManager before using the Bazaarvoice SDK.");

  // Cool, clientId and passKey are valid.

  NSUInteger limit = request.limit;

  if (limit <= 0 || limit > 50) {
    limit = 20; // default limit
  }

  NSString *sdkVersionParam =
      [NSString stringWithFormat:@"%@=%@", @"_bvIosSdkVersion", BV_SDK_VERSION];

  NSString *idParam =
      [NSString stringWithFormat:@"magpie_idfa_%@", [self getIdfaString]];

  NSString *endPoint = [NSString
      stringWithFormat:
          @"%@/recommendations/%@?%@&passKey=%@&limit=%lu&client=%@", apiRoot,
          idParam, sdkVersionParam, apiKey, (unsigned long)limit, client];

  NSString *trimmedProductId = [request.productId
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  if (trimmedProductId && 0 < trimmedProductId.length) {

    endPoint = [endPoint
        stringByAppendingString:[NSString stringWithFormat:@"&product=%@/%@",
                                                           client,
                                                           trimmedProductId]];
  }

  NSString *trimmedCategoryId = [request.categoryId
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  if (trimmedCategoryId && 0 < trimmedCategoryId.length) {
    endPoint = [endPoint
        stringByAppendingString:[NSString stringWithFormat:@"&category=%@/%@",
                                                           client,
                                                           trimmedCategoryId]];
  }

  if (request.allowInactiveProducts) {
    endPoint =
        [endPoint stringByAppendingString:@"&allow_inactive_products=true"];
  }

  double avgRating =
      (request.averageRating && !isnan(request.averageRating.doubleValue) &&
       0.0f <= request.averageRating.doubleValue &&
       BVRECOMMENDATIONSREQUEST_MAX_AVG_RATING >=
           request.averageRating.doubleValue)
          ? request.averageRating.doubleValue
          : -1.0f;

  if (0.0f <= avgRating) {
    endPoint = [endPoint
        stringByAppendingString:[NSString
                                    stringWithFormat:@"&min_avg_rating=%0.5f",
                                                     avgRating]];
  }

  NSString *trimmedBrandId = [request.brandId
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  if (trimmedBrandId && 0 < trimmedBrandId.length) {
    endPoint = [endPoint
        stringByAppendingString:[NSString stringWithFormat:@"&bvbrandid=%@",
                                                           trimmedBrandId]];
  }

  NSString *trimmedInterest = [request.interest
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  if (trimmedInterest && 0 < trimmedInterest.length) {
    endPoint = [endPoint
        stringByAppendingString:[NSString stringWithFormat:@"&interest=%@",
                                                           trimmedInterest]];
  }

  NSString *includes = [[request.includes.allObjects
      sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull lhs,
                                                     id _Nonnull rhs) {
        NSString *lhsString = [NSString stringWithFormat:@"%@", lhs];
        NSString *rhsString = [NSString stringWithFormat:@"%@", rhs];
        return [lhsString compare:rhsString];
      }] componentsJoinedByString:@","];
  if (includes && 0 < includes.length) {
    endPoint = [endPoint
        stringByAppendingString:[NSString
                                    stringWithFormat:@"&include=%@", includes]];
  }

  if (request.locale) {
    endPoint = [endPoint
        stringByAppendingString:[NSString
                                    stringWithFormat:@"&locale=%@",
                                                     request.locale
                                                         .localeIdentifier]];
  }

  if (request.lookback) {
    /*
     * For now we use seconds as a lookback since the backend API uses the
     * measure as a LONG. If this is running on 32 bit instances (the
     * pathological case for this study; likely common though) then the MAX
     * value is 2147483647. This is equal to 68 years. If, however, this is on
     * an 64 bit instance then it's 9223372036854775807 which is roughly
     * 292471208677 years. Either way, this will likely not need to change,
     * however, it would be trivial to convert this to minutes, hours. etc.
     *
     * (Oh, and if it's not obvious, NSDateComponents store values in NSIntegers
     * which are 32 bits and 64 bits on their respective platforms. Which means
     * that anything shipped before the iPhone 5s is 32 bit, whereas, everything
     * else is 64 bit.)
     */
    NSDateComponents *secondsComponent =
        [[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                        fromDate:request.lookback
                                          toDate:[NSDate date]
                                         options:0x0];

    if (0 < secondsComponent.second) {
      NSString *duration =
          [NSString stringWithFormat:@"%lus", secondsComponent.second];

      endPoint = [endPoint
          stringByAppendingString:[NSString stringWithFormat:@"&lookback=%@",
                                                             duration]];
    }
  }

  if (request.purposeIsSet) {
    endPoint = [endPoint
        stringByAppendingString:
            [NSString
                stringWithFormat:@"&purpose=%@",
                                 [BVRecommendationsRequestOptionsUtil
                                     valueForRecommendationsRequestPurpose:
                                         request.purpose]]];
  }

  NSString *trimmedRequiredCategory = [request.requiredCategory
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  if (trimmedRequiredCategory && 0 < trimmedRequiredCategory.length) {
    endPoint = [endPoint
        stringByAppendingString:
            [NSString stringWithFormat:@"&required_category=%@/%@", client,
                                       trimmedRequiredCategory]];
  }

  NSString *strategies = [[request.strategies.allObjects
      sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull lhs,
                                                     id _Nonnull rhs) {
        NSString *lhsString = [NSString stringWithFormat:@"%@", lhs];
        NSString *rhsString = [NSString stringWithFormat:@"%@", rhs];
        return [lhsString compare:rhsString];
      }] componentsJoinedByString:@","];
  if (strategies && 0 < strategies.length) {
    endPoint = [endPoint
        stringByAppendingString:[NSString stringWithFormat:@"&strategies=%@",
                                                           strategies]];
  }

  return [NSURL URLWithString:endPoint];
}

- (NSString *)getIdfaString {
  if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier]
        UUIDString];
  } else {
    return @"nontracking";
  }
}

- (BOOL)isSDKValid {
  NSString *clientId = [BVSDKManager sharedManager].configuration.clientId;
  NSString *passKey =
      [BVSDKManager sharedManager].configuration.apiKeyShopperAdvertising;

  if (clientId == nil || passKey == nil || [clientId isEqualToString:@""] ||
      [passKey isEqualToString:@""]) {
    return NO;
  }

  return YES;
}

- (NSError *)invalidSDKError {
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

  NSString *clientId = [BVSDKManager sharedManager].configuration.clientId;
  NSString *passKey =
      [BVSDKManager sharedManager].configuration.apiKeyShopperAdvertising;

  if ([clientId isEqualToString:@""]) {
    [userInfo setValue:@"Client Id is not set."
                forKey:NSLocalizedDescriptionKey];
  }

  if ([passKey isEqualToString:@""]) {
    [userInfo setValue:@"apiKeyShopperAdvertising is not set."
                forKey:NSLocalizedDescriptionKey];
  }

  return [NSError errorWithDomain:BVErrDomain code:-1 userInfo:userInfo];
}

@end
