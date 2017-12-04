//
//  BVNotificationConfiguration.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationConfiguration.h"
#import "BVCore.h"

@implementation BVNotificationConfiguration

+ (void)
loadGeofenceConfiguration:(nonnull NSURL *)url
               completion:(nonnull void (^)(BVStoreReviewNotificationProperties
                                                *__nonnull response))completion
                  failure:(nonnull void (^)(NSError *__nonnull errors))failure {
  [self loadConfiguration:url
               completion:^(NSDictionary *response, NSError *error) {

                 if (response == nil && error == nil) {
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

                 if (response == nil && error == nil) {
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

  NSURLSession *session = [NSURLSession sharedSession];
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
              completion(jsonDict, nil);
            }

          } else {
            completion(nil, error);
          }

        }];

  // start the request
  [task resume];
}

@end
