//
//  BVGetShopperProfile.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>

#import "BVCore.h"
#import "BVGetShopperProfile.h"
#import "BVAnalyticsManager.h"
#import "BVRecsAnalyticsHelper.h"
#import "BVShopperProfileRequestCache.h"

@implementation BVGetShopperProfile

- (void)_privateFetchShopperProfile:(NSString * __nullable)productId
                             withCategoryId:(NSString * __nullable)categoryId
                         withProfileOptions:(BVProfileFilterOptions)profileOptions
                                  withLimit:(NSUInteger)limit
                          completionHandler:(void (^)(BVShopperProfile * __nullable profile, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler {
    
    BVShopperProfileRequestCache *cache = [BVShopperProfileRequestCache sharedCache];
    
    BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
    NSString *client = sdkMgr.clientId;
    NSString *apiRoot = sdkMgr.urlRootShopperAdvertising;
    NSString *apiKey = sdkMgr.apiKeyShopperAdvertising;
    
    assert(apiKey != nil);
    assert(client != nil);
    
    NSString *idfaString = nil;
    
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    } else {
        idfaString = @"nontracking";
    }
    
    if (limit <= 0 || limit > 50){
        limit = 20; // default limit
    }
    
    NSString *idParam = [NSString stringWithFormat:@"magpie_idfa_%@", idfaString];
    
    NSString *filterTypes = [self createProfileFilterFlags:profileOptions];
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/recommendations/%@?passKey=%@&include=%@&limit=%lu", apiRoot, idParam, apiKey, filterTypes, (unsigned long)limit];
    
    if (client != nil && ![client isEqualToString:@"apitestcustomer"]){
        endPoint = [endPoint stringByAppendingString:[NSString stringWithFormat:@"&client=%@", client]];
    }
    
    if (productId != nil && client != nil){
        endPoint = [endPoint stringByAppendingString:[NSString stringWithFormat:@"&product=%@/%@", client, productId]];
    }
    
    if (categoryId != nil){
        endPoint = [endPoint stringByAppendingString:[NSString stringWithFormat:@"&category=%@", categoryId]];
    }
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", endPoint]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:endPoint]];
    
    NSCachedURLResponse *cachedResp = [cache cachedResponseForRequest:request];
    
    if (cachedResp){
        
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:cachedResp.data options:kNilOptions error:nil];
        
        BVShopperProfile *profile = [[BVShopperProfile alloc] initWithDictionary:responseDict];
        
        [cache printCacheSize];
        
        [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"CACHED RESPONSE: %@", responseDict]];
        
        completionHandler(profile, cachedResp.response, nil);
        
        return;
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;
        
        if ((!error && urlResp.statusCode < 300) && data != nil){
            
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
            
            NSError *errorJSON;
            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJSON];
            
            if (!errorJSON){
                
                BVShopperProfile *profile = [[BVShopperProfile alloc] initWithDictionary:responseDict];
                
                [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: (%ld): %@", (long)httpResp.statusCode, responseDict]];
                
                // Successful response, save in cache
                NSCachedURLResponse *newCachedResp = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                
                [cache storeCachedResponse:newCachedResp forRequest:request];
                
                // Success! Notify completion handler
                completionHandler(profile, response, nil);
                
            } else {
                //serialization error
                completionHandler(nil, nil, errorJSON);
                return;
            }
            
        } else {
            // request error
            if (error){
                completionHandler(nil, nil, error);
                return;
            } else {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: urlResp.description };
                NSError *err = [NSError errorWithDomain:BVErrDomain code:urlResp.statusCode userInfo:userInfo];
                completionHandler(nil, nil, err);
                return;
            }
        }

        
    }];
    
    [task resume];
    
}

- (NSString *)createProfileFilterFlags:(BVProfileFilterOptions)profileOptions {
    
    NSString *filterTypes = @"";
    if (profileOptions == 0){
        filterTypes = @"interests,brands,recommendations,reviews";
    } else {
        
        if (profileOptions & eOptionBrands){
            filterTypes = @"brands";
        }
        
        if (profileOptions & eOptionRecommendations){
            if (filterTypes.length) {
                filterTypes = [filterTypes stringByAppendingString:@","];
            }
            filterTypes =[filterTypes stringByAppendingString:@"interests"];
            
        }
        if (profileOptions & eOptionInterests){
            
            if (filterTypes.length) {
                filterTypes = [filterTypes stringByAppendingString:@","];
            }
            filterTypes = [filterTypes stringByAppendingString:@"recommendations"];
        }
        if (profileOptions & eOptionReviews){
            
            if (filterTypes.length) {
                filterTypes = [filterTypes stringByAppendingString:@","];
            }
            filterTypes = [filterTypes stringByAppendingString:@"reviews"];
        }
    }

    return filterTypes;
    
}


- (void)fetchProductRecommendationsForProduct:(NSString *)productId
                                    withLimit:(NSUInteger)limit
                        withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler;{
    
    
    [self _privateFetchShopperProfile:productId withCategoryId:nil withProfileOptions:0 withLimit:limit completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        completionHandler(profile, error);
        
    }];
    
}

- (void)fetchProductRecommendationsForCategory:(NSString *)categoryId
                                    withLimit:(NSUInteger)limit
                        withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler;{
    

    [self _privateFetchShopperProfile:nil withCategoryId:categoryId withProfileOptions:0 withLimit:limit completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        completionHandler(profile, error);
        
    }];
    
}


- (void)fetchProductRecommendations:(NSUInteger)limit withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler{
    
    [self _privateFetchShopperProfile:nil withCategoryId:nil withProfileOptions:0 withLimit:limit completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        completionHandler(profile, error);
        
    }];
    
}

-(NSString*)urlEncode:(NSString*)originalString {
    
    NSMutableCharacterSet* charsToEncode = [NSMutableCharacterSet characterSetWithCharactersInString:@"`=[]\\;#%^&+{}|\"<>?"];
    [charsToEncode invert];
    NSString* encodedStringWithSpaces = [originalString stringByAddingPercentEncodingWithAllowedCharacters:charsToEncode];
    return [encodedStringWithSpaces stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

-(void)setMaxCacheAge:(NSInteger)maxCacheAge{
    
    _maxCacheAge = maxCacheAge;
    [BVShopperProfileRequestCache sharedCache].cacheMaxAgeInSeconds = _maxCacheAge;
    
}

@end
