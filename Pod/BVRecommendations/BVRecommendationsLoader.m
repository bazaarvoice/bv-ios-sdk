//
//  BVRecommendationsLoader.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>

#import "BVCore.h"
#import "BVRecommendationsLoader.h"
#import "BVAnalyticsManager.h"
#import "BVRecsAnalyticsHelper.h"
#import "BVShopperProfileRequestCache.h"
#import "BVSDKConfiguration.h"

@implementation BVRecommendationsLoader

- (void)loadRequest:(BVRecommendationsRequest*)request
  completionHandler:(recommendationsCompletionHandler)completionHandler
       errorHandler:(recommendationsErrorHandler)errorHandler {
    
    // check if SDK is properly configured
    // if not, hit the error handler
    if([self isSDKValid] == false) {
        
        [self errorOnMainThread:[self invalidSDKError] handler:errorHandler];
        return;
        
    }
    
    BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
    NSString *client = sdkMgr.configuration.clientId;
    NSString *apiRoot = sdkMgr.urlRootShopperAdvertising;
    NSString *apiKey = sdkMgr.configuration.apiKeyShopperAdvertising;
    
    // check that `apiKeyShopperAdvertising` is valid. Will fail only in debug mode.
    NSAssert(apiKey.length, @"You must supply apiKeyShopperAdvertising in the BVSDKManager before using the Bazaarvoice SDK.");
    
    // Cool, clientId and passKey are valid.
    
    BVShopperProfileRequestCache *cache = [BVShopperProfileRequestCache sharedCache];
    
    NSUInteger limit = request.limit;
    NSString* productId = request.productId;
    NSString* categoryId = request.categoryId;
    
    NSString *idfaString = [self getIdfaString];
    
    if (limit <= 0 || limit > 50){
        limit = 20; // default limit
    }
    
    NSString *idParam = [NSString stringWithFormat:@"magpie_idfa_%@", idfaString];
    
    NSString *filterTypes = @"interests,brands,recommendations,reviews";
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/recommendations/%@?passKey=%@&include=%@&limit=%lu&client=%@", apiRoot, idParam, apiKey, filterTypes, (unsigned long)limit, client];
    
    if (productId != nil){
        endPoint = [endPoint stringByAppendingString:[NSString stringWithFormat:@"&product=%@/%@", client, productId]];
    }
    
    if (categoryId != nil){
        endPoint = [endPoint stringByAppendingString:[NSString stringWithFormat:@"&category=%@", categoryId]];
    }
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", endPoint]];
    
    NSURLRequest *networkRequest = [NSURLRequest requestWithURL:
                                    [NSURL URLWithString:endPoint]];
    
    NSCachedURLResponse *cachedResp = [cache cachedResponseForRequest:networkRequest];
    
    if (cachedResp){
        
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:cachedResp.data options:kNilOptions error:nil];
        
        BVShopperProfile *profile = [[BVShopperProfile alloc] initWithDictionary:responseDict];
        
        [cache printCacheSize];
        
        [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"CACHED RESPONSE: %@", responseDict]];
        
        [self completionOnMainThread:profile.recommendations handler:completionHandler];
        
        return;
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:networkRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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
                
                [cache storeCachedResponse:newCachedResp forRequest:networkRequest];
                
                // Success!
                [self completionOnMainThread:profile.recommendations handler:completionHandler];
                
                return;
                
            } else {
                //serialization error
                [self errorOnMainThread:errorJSON handler:errorHandler];
                return;
            }
            
        } else {
            // request error
            if (error){
                [self errorOnMainThread:error handler:errorHandler];
                return;
            } else {
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: urlResp.description };
                NSError *err = [NSError errorWithDomain:BVErrDomain code:urlResp.statusCode userInfo:userInfo];
                [self errorOnMainThread:err handler:errorHandler];
                return;
            }
        }
        
        
    }];
    
    [task resume];
    
}

-(void)completionOnMainThread:(NSArray<BVRecommendedProduct*>*)recommendations handler:(recommendationsCompletionHandler)completionHandler {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(recommendations);
    });
    
}

-(void)errorOnMainThread:(NSError*)error handler:(recommendationsErrorHandler)errorHandler {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        errorHandler(error);
    });
    
}

-(NSString*)getIdfaString {
    
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    } else {
        return @"nontracking";
    }
    
}

-(BOOL)isSDKValid {
    
    NSString* clientId = [BVSDKManager sharedManager].configuration.clientId;
    NSString* passKey  = [BVSDKManager sharedManager].configuration.apiKeyShopperAdvertising;
    
    if (clientId == nil || passKey == nil || [clientId isEqualToString:@""] || [passKey isEqualToString:@""]) {
        return false;
    }
    
    return true;
    
}

-(NSError*)invalidSDKError {
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];

    NSString* clientId = [BVSDKManager sharedManager].configuration.clientId;
    NSString* passKey  = [BVSDKManager sharedManager].configuration.apiKeyShopperAdvertising;
    
    if([clientId isEqualToString:@""]) {
        [userInfo setValue:@"Client Id is not set." forKey:NSLocalizedDescriptionKey];
    }
    
    if ([passKey isEqualToString:@""]) {
        [userInfo setValue:@"apiKeyShopperAdvertising is not set." forKey:NSLocalizedDescriptionKey];
    }

    return [NSError errorWithDomain:BVErrDomain code:-1 userInfo:userInfo];
    
}

@end
