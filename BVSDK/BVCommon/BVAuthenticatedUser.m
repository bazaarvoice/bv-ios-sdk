//
//  BVAuthenticatedUser.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVAuthenticatedUser+Testing.h"
#import "BVCommon.h"
#import "BVNetworkingManager.h"
#import <AdSupport/AdSupport.h>

@interface BVAuthenticatedUser ()

@property NSDictionary *personalizedPreferences;

@end

@implementation BVAuthenticatedUser

- (void)updateProfile:(bool)force
           withAPIKey:(NSString *)passKey
            isStaging:(BOOL)isStage {
// don't grab profile if user has opted for limited ad targeting
#ifdef DISABLE_BVSDK_IDFA
  return;
#else
  if (![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
    return;
  }

  NSAssert(passKey && 0 < passKey.length,
           @"You must supply apiKeyShopperAdvertising in the BVSDKManager.");

  if (force || [self shouldUpdateProfile]) {
    NSString *idfa = [
        [[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *adsPassKey = passKey;
    NSString *baseUrl = [BVSDKManager sharedManager].urlRootShopperAdvertising;

    NSString *profileUrl =
        [NSString stringWithFormat:@"%@/users/magpie_idfa_%@?passkey=%@",
                                   baseUrl, idfa, adsPassKey];

    [[BVLogger sharedLogger]
        verbose:[NSString stringWithFormat:@"GET: %@", profileUrl]];

    /// For private classes we ask for the NSURLSession but we don't hand back
    /// any objects since it would be useless to the developers as they have no
    /// interface to the object graph.
    NSURLSession *session = nil;
    id<BVURLSessionDelegate> sessionDelegate =
        [BVSDKManager sharedManager].urlSessionDelegate;
    if (sessionDelegate && [sessionDelegate respondsToSelector:@selector
                                            (URLSessionForBVObject:)]) {
      session = [sessionDelegate URLSessionForBVObject:nil];
    }

    session =
        session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

    NSURLSessionDataTask *profileTask = [session
          dataTaskWithURL:[NSURL URLWithString:profileUrl]
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *error) {

          // Completion
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          if ((httpResponse && httpResponse.statusCode < 300) && data) {
            // Success

            NSError *errorJson;
            NSDictionary *responseDict =
                [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&errorJson];

            NSString *jasonString =
                [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"jsonString: %@", jasonString);

            if (!errorJson) {
              // JSON response parsing.
              [[BVLogger sharedLogger]
                  verbose:[NSString
                              stringWithFormat:@"RESPONSE: (%ld): %@",
                                               (long)httpResponse.statusCode,
                                               responseDict]];

              if ([self.personalizedPreferences
                      isEqualToDictionary:responseDict]) {
                return; // No update
              }

              NSString *message =
                  [NSString stringWithFormat:@"Profile for current "
                                             @"user (may take a few "
                                             @"moments to update): %@",
                                             responseDict];
              [[BVLogger sharedLogger] info:message];

              self.personalizedPreferences = responseDict;

            } else {
              // Malformed JSON
              NSString *errString = [NSString
                  stringWithFormat:@"ERROR: Authenticated User Profile "
                                   @"JSON error: %@",
                                   errorJson.localizedDescription];
              [[BVLogger sharedLogger] error:errString];
            }

            // For testing
            dispatch_async(dispatch_get_main_queue(), ^{
              [[NSNotificationCenter defaultCenter]
                  postNotificationName:BV_INTERNAL_PROFILE_UPDATED_COMPLETED
                                object:self];
            });

          } else {
            // Failure
            NSString *errString = [NSString
                stringWithFormat:@"ERROR: Authenticated User Profile "
                                 @"response. HTTP Status(%ld) with "
                                 @"error: %@",
                                 (long)httpResponse.statusCode, error];
            [[BVLogger sharedLogger] error:errString];

            // For testing
            dispatch_async(dispatch_get_main_queue(), ^{
              [[NSNotificationCenter defaultCenter]
                  postNotificationName:BV_INTERNAL_PROFILE_UPDATED_COMPLETED
                                object:nil];
            });
          }

        }];

    [profileTask resume];
  }

#endif // DISABLE_BVSDK_IDFA
}

- (bool)shouldUpdateProfile {
  // Return true if the profile does not have any targeting keywords at all
  return ![self getTargetingKeywords] ||
         [[self getTargetingKeywords] allKeys].count == 0;
}

- (NSDictionary *)getTargetingKeywords {
#ifdef DISABLE_BVSDK_IDFA
  bool trackingEnabled = false;
#else
  bool trackingEnabled =
      [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
#endif

  if (!self.personalizedPreferences || !trackingEnabled)
    return nil;

  NSDictionary *profile =
      [self.personalizedPreferences objectForKey:@"profile"];
  if (!profile) {
    return nil;
  }

  NSMutableDictionary *targetingInfo = [NSMutableDictionary dictionary];

  for (NSString *key in profile) {
    // ensure we don't include profile id
    if ([key isEqualToString:@"id"] == false) {
      NSDictionary *value = [profile objectForKey:key];
      if (value && [value count] > 0) {
        [targetingInfo setObject:[self generateString:value] forKey:key];
      }
    }
  }

  return targetingInfo;
}

- (NSString *)generateString:(NSDictionary *)dict {
  NSMutableArray *keywords = [NSMutableArray array];
  for (NSString *key in [dict allKeys]) {
    NSString *val = [dict objectForKey:key];
    [keywords addObject:[NSString stringWithFormat:@"%@_%@", key, val]];
  }

  return [keywords componentsJoinedByString:@" "];
}

@end
