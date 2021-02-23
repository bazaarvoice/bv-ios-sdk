//
//  BVAuthenticatedUser.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVAuthenticatedUser+Testing.h"
#import "BVAnalyticEventManager.h"
#import "BVCommon.h"
#import "BVLogger+Private.h"
#import "BVNetworkingManager.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/ATTrackingManager.h>

@interface BVAuthenticatedUser ()

@property NSDictionary *personalizedPreferences;

@end

@implementation BVAuthenticatedUser

- (void)updateProfile:(BOOL)force
           withAPIKey:(NSString *)passKey
            isStaging:(BOOL)isStage {
// don't grab profile if user has opted for limited ad targeting
#ifdef DISABLE_BVSDK_IDFA
    
    if (@available(iOS 14, *)) {
        if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusNotDetermined) {
            [BVAnalyticEventManager.sharedManager requestIDFA];
        }
    }
    
    return;
#else
    if ([BVAnalyticEventManager.sharedManager isAdvertisingTrackingEnabled]) {
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

    BVLogVerbose(([NSString stringWithFormat:@"GET: %@", profileUrl]),
                 BV_PRODUCT_COMMON);

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
              BVLogVerbose(
                  ([NSString stringWithFormat:@"RESPONSE: (%ld): %@",
                                              (long)httpResponse.statusCode,
                                              responseDict]),
                  BV_PRODUCT_COMMON);

              if ([self.personalizedPreferences
                      isEqualToDictionary:responseDict]) {
                return; // No update
              }

              NSString *message =
                  [NSString stringWithFormat:@"Profile for current "
                                             @"user (may take a few "
                                             @"moments to update): %@",
                                             responseDict];
              BVLogInfo(message, BV_PRODUCT_COMMON);

              self.personalizedPreferences = responseDict;

            } else {
              // Malformed JSON
              NSString *errString = [NSString
                  stringWithFormat:@"ERROR: Authenticated User Profile "
                                   @"JSON error: %@",
                                   errorJson.localizedDescription];
              BVLogError(errString, BV_PRODUCT_COMMON);
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
            BVLogError(errString, BV_PRODUCT_COMMON);

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

- (BOOL)shouldUpdateProfile {
  // Return true if the profile does not have any targeting keywords at all
  return ![self getTargetingKeywords] ||
         [[self getTargetingKeywords] allKeys].count == 0;
}

- (NSDictionary *)getTargetingKeywords {
    
    if (@available(iOS 14, *)) {
        if ([ATTrackingManager trackingAuthorizationStatus] == ATTrackingManagerAuthorizationStatusNotDetermined) {
            [BVAnalyticEventManager.sharedManager requestIDFA];
        }
    }
    
#ifdef DISABLE_BVSDK_IDFA
    BOOL trackingEnabled = NO;
#else
    BOOL trackingEnabled = [BVAnalyticEventManager.sharedManager isAdvertisingTrackingEnabled];
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
        if (![key isEqualToString:@"id"]) {
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
