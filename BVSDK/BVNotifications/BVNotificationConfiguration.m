//
//  BVNotificationConfiguration.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationConfiguration.h"
#import "BVCommon.h"
#import "BVNetworkingManager.h"

@implementation BVNotificationConfiguration

+ (void)
loadGeofenceConfiguration:(nonnull NSURL *)url
               completion:(nonnull void (^)(BVStoreReviewNotificationProperties
                                                *__nonnull response))completion
                  failure:(nonnull void (^)(NSError *__nonnull errors))failure {
  [self loadConfiguration:url
               completion:^(NSDictionary *response, NSError *error) {

                 if (!response && !error) {
                   NSString *errorMessage = @"No config found for geofence "
                                            @"notifications. Will not post "
                                            @"notification.";
                   [[BVLogger sharedLogger] error:errorMessage];
                   [NSError errorWithDomain:BVErrDomain
                                       code:-1
                                   userInfo:@{@"message" : errorMessage}];
                   return failure(error);
                 }

                 if (!error) {
                   BVStoreReviewNotificationProperties *props =
                       [[BVStoreReviewNotificationProperties alloc]
                           initWithDictionary:response];
                   completion(props);

                 } else {
                   [[BVLogger sharedLogger]
                       error:[NSString
                                 stringWithFormat:@"Failed to fetch store "
                                                  @"notification "
                                                  @"configuration: %@",
                                                  error.localizedDescription]];
                   failure(error);
                 }
               }];
}

+ (void)
loadPINConfiguration:(nonnull NSURL *)url
          completion:(nonnull void (^)(BVProductReviewNotificationProperties
                                           *__nonnull response))completion
             failure:(nonnull void (^)(NSError *__nonnull errors))failure {
  [self loadConfiguration:url
               completion:^(NSDictionary *response, NSError *error) {

                 if (!response && !error) {
                   NSString *errorMessage = @"No notification config found "
                                            @"for PIN. Will not post "
                                            @"notifications.";
                   [[BVLogger sharedLogger] error:errorMessage];
                   [NSError errorWithDomain:BVErrDomain
                                       code:-1
                                   userInfo:@{@"message" : errorMessage}];
                   return failure(error);
                 }

                 if (!error) {
                   BVProductReviewNotificationProperties *props =
                       [[BVProductReviewNotificationProperties alloc]
                           initWithDictionary:response];
                   completion(props);
                 } else {
                   [[BVLogger sharedLogger]
                       error:[NSString
                                 stringWithFormat:@"Failed to fetch store "
                                                  @"notification "
                                                  @"configuration: %@",
                                                  error.localizedDescription]];
                   failure(error);
                 }
               }];
}

+ (void)loadConfiguration:(nonnull NSURL *)url
               completion:(nonnull void (^)(NSDictionary *__nullable response,
                                            NSError *error))completion {
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

  [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", url]];

  /// For private classes we ask for the NSURLSession but we don't hand back any
  /// objects since it would be useless to the developers as they have no
  /// interface to the object graph.
  NSURLSession *session = nil;
  id<BVURLSessionDelegate> sessionDelegate =
      [BVSDKManager sharedManager].urlSessionDelegate;
  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector(URLSessionForBVObject:)]) {
    session = [sessionDelegate URLSessionForBVObject:nil];
  }

  session = session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSURLSessionDataTask *task = [session
      dataTaskWithRequest:urlRequest
        completionHandler:^(NSData *__nullable data,
                            NSURLResponse *__nullable response,
                            NSError *__nullable error) {

          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

          if (!error && httpResponse.statusCode < 300) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization
                JSONObjectWithData:data
                           options:NSJSONReadingMutableLeaves
                             error:&jsonError];
            if (jsonDict) {

              dispatch_async(dispatch_get_main_queue(), ^{
                completion(jsonDict, nil);
              });
            }

          } else {

            dispatch_async(dispatch_get_main_queue(), ^{
              completion(nil, error);
            });
          }

        }];

  // start the request
  [task resume];
}

@end
