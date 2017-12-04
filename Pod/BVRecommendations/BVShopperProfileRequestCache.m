//
//  BVShopperProfileRequestCache.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVShopperProfileRequestCache.h"
#import "BVLogger.h"

NSString *const CACHE_DATE_KEY = @"cache date";

@implementation BVShopperProfileRequestCache

+ (instancetype)sharedCache {
  static dispatch_once_t p = 0;
  __strong static id _sharedObject = nil;
  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });

  return _sharedObject;
}

- (id)init {

  _cacheMaxAgeInSeconds = 60;
  return [super initWithMemoryCapacity:(2 * 1024 * 1024)
                          diskCapacity:0
                              diskPath:@"com.bv.recs.cache"];
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {

  NSCachedURLResponse *cachedResponse =
      [super cachedResponseForRequest:request];
  if (cachedResponse) {
    NSDate *cacheDate = [[cachedResponse userInfo] objectForKey:CACHE_DATE_KEY];
    if ([cacheDate timeIntervalSinceNow] < -(_cacheMaxAgeInSeconds) ||
        cacheDate == nil) {
      [self removeCachedResponseForRequest:request];
      cachedResponse = nil;
    }
  }

  return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
                 forRequest:(NSURLRequest *)request {

  NSMutableDictionary *userInfo = cachedResponse.userInfo
                                      ? [cachedResponse.userInfo mutableCopy]
                                      : [NSMutableDictionary dictionary];
  [userInfo setObject:[NSDate date] forKey:CACHE_DATE_KEY];
  NSCachedURLResponse *newCachedResponse = [[NSCachedURLResponse alloc]
      initWithResponse:cachedResponse.response
                  data:cachedResponse.data
              userInfo:userInfo
         storagePolicy:cachedResponse.storagePolicy];

  [super storeCachedResponse:newCachedResponse forRequest:request];
}

- (void)printCacheSize {

  [[BVLogger sharedLogger]
      verbose:[NSString stringWithFormat:
                            @"NSURLCache Memory/Disk Size: %ld/%ld (bytes)",
                            (unsigned long)[self currentMemoryUsage],
                            (unsigned long)[self currentDiskUsage]]];
}

@end