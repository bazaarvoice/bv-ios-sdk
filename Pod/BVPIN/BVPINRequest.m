//
//  BVPINRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVPINRequest.h"
#import "BVLogger.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import <AdSupport/AdSupport.h>

@implementation BVPINRequest

+ (void)getPendingPINs:
            (nonnull void (^)(NSArray<BVPIN *> *__nonnull pins))completion
               failure:(nonnull void (^)(NSError *__nonnull))failure {
  NSString *idfa =
      [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

  NSURL *url = [NSURL
      URLWithString:[NSString
                        stringWithFormat:@"https://api.bazaarvoice.com/pin/"
                                         @"toreview?passkey=%@&bvid=magpie_"
                                         @"idfa_%@&client=%@",
                                         [BVSDKManager sharedManager]
                                             .configuration.apiKeyPIN,
                                         idfa,
                                         [BVSDKManager sharedManager]
                                             .configuration.clientId]];
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
            NSArray *jsonArr = [NSJSONSerialization
                JSONObjectWithData:data
                           options:NSJSONReadingMutableContainers
                             error:&jsonError];
            if (jsonArr) {
              NSMutableArray *pins = [NSMutableArray new];
              for (NSDictionary *obj in jsonArr) {
                [pins addObject:[[BVPIN alloc] initWithDictionary:obj]];
              }
              [[BVLogger sharedLogger]
                  verbose:[NSString stringWithFormat:@"%@", jsonArr]];
              dispatch_async(dispatch_get_main_queue(), ^{
                completion([NSArray arrayWithArray:pins]);
              });
            } else {
              error =
                  [NSError errorWithDomain:BVErrDomain
                                      code:BV_ERROR_PARSING_FAILED
                                  userInfo:@{
                                    NSLocalizedDescriptionKey :
                                        @"An unknown parsing error occurred."
                                  }];
              dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
              });
            }
          } else {
            if (error == nil) {
              error = [NSError errorWithDomain:BVErrDomain
                                          code:httpResponse.statusCode
                                      userInfo:httpResponse.allHeaderFields];
            }
            [[BVLogger sharedLogger] printError:error];
            dispatch_async(dispatch_get_main_queue(), ^{
              failure(error);
            });
          }
        }];

  [task resume];
}

@end
