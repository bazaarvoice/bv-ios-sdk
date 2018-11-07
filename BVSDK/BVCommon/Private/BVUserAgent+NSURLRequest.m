//
//  BVUserAgent+NSURLRequest.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVUserAgent+NSURLRequest.h"
#import <UIKit/UIKit.h>

@implementation NSURLRequest (UserAgent)

+ (nonnull NSString *)bvUserAgentWithLocaleIdentifier:
    (nullable NSString *)localeIdentifier;
{
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

  NSString *osVersion = [[[UIDevice currentDevice] systemVersion]
      stringByReplacingOccurrencesOfString:@"."
                                withString:@"_"];

  NSString *model = [[UIDevice currentDevice] model];

  NSString *majorMinor =
      [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  NSString *build =
      [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];

  NSString *appVersion =
      (majorMinor && build)
          ? [NSString stringWithFormat:@"%@.%@", majorMinor, build]
          : @"0.0.0";

  NSString *os =
      (NSOrderedSame == [model compare:@"iPad"]) ? @"OS" : @"iPhone OS";

  return [NSString
      stringWithFormat:
          @"Mozilla/5.0 (%@; U; CPU %@ %@ like Mac OS X; %@) AppleWebKit/0.0.0 "
          @"(KHTML, like Gecko) Version/%@ Mobile/XXX Safari/0.0.0",
          model, os, osVersion, localeIdentifier, appVersion];
}

@end
