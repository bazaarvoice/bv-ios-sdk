//
//  BVShopperProfileRequestCache.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// For internal use only.
@interface BVShopperProfileRequestCache : NSURLCache

+(instancetype)sharedCache;

-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request;

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request;

- (void)printCacheSize;

@property NSInteger cacheMaxAgeInSeconds;

@end
