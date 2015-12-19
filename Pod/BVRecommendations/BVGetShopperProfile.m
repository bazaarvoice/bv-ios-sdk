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

@implementation BVGetShopperProfile

- (void)_privateFetchShopperProfileWithIDFA:(NSString *)IDFA
                                    withOptions:(BVProfileFilterOptions)filter
                                    withLimit:(NSUInteger)limit
                                    completionHandler:(void (^)(BVShopperProfile * __nullable profile, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
    
    BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
    NSString *client = sdkMgr.clientId;
    NSString *apiRoot = sdkMgr.urlRootShopperAdvertising;
    NSString *apiKey = sdkMgr.apiKeyShopperAdvertising;
    
    assert(apiKey != nil);
    assert(client != nil);
    
    if (!IDFA){
        IDFA = @"nontracking";
    }
    
    if (limit <= 0 || limit > 50){
        limit = 20; // default limit
    }
    
    NSString *idParam = [NSString stringWithFormat:@"magpie_idfa_%@", IDFA];
    
    NSString *filterTypes = @"";
    if (filter == 0){
        filterTypes = @"interests,brands,recommendations,reviews";
    } else {
        
        if (filter & eOptionBrands){
            filterTypes = @"brands";
        }
            
        if (filter & eOptionRecommendations){
            if (filterTypes.length) {
                filterTypes = [filterTypes stringByAppendingString:@","];
            }
            filterTypes =[filterTypes stringByAppendingString:@"interests"];
            
            }
        if (filter & eOptionInterests){
            
            if (filterTypes.length) {
                filterTypes = [filterTypes stringByAppendingString:@","];
            }
            filterTypes = [filterTypes stringByAppendingString:@"recommendations"];
        }
        if (filter & eOptionReviews){
            
            if (filterTypes.length) {
                filterTypes = [filterTypes stringByAppendingString:@","];
            }
            filterTypes = [filterTypes stringByAppendingString:@"reviews"];
        }
    }
    
    NSString *endPoint = [NSString stringWithFormat:@"%@/shopper/recommendations/%@?passKey=%@&include=%@&limit=%lu", apiRoot, idParam, apiKey, filterTypes, (unsigned long)limit];
    
    if (client != nil){
        endPoint = [endPoint stringByAppendingString:[NSString stringWithFormat:@"&client=%@", client]];
    }


    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", endPoint]];
    
    
    NSURL *url = [NSURL URLWithString:endPoint];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   
       NSHTTPURLResponse *urlResp = (NSHTTPURLResponse *)response;
                                              
       if (!error && urlResp.statusCode < 300){
          NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
          
          NSError *errorJSON;
          NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJSON];
          
           BVShopperProfile *profile = [[BVShopperProfile alloc] initWithDictionary:responseDict];
           
          if (!errorJSON){
              [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: (%ld): %@", (long)httpResp.statusCode, responseDict]];
          
              // Fire analytics event

              dispatch_async(dispatch_get_main_queue(), ^{
                  // Send an analytics event for a recommendation profile request
                  [BVRecsAnalyticsHelper createAnalyticsRecommendationEventFromProfile:profile];
              });
              
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
    
    [downloadTask resume];

}


- (void)fetchProductRecommendations:(NSUInteger)limit withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler{
    
    NSString *idfaString = nil;
    
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
       idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    
    
    [self _privateFetchShopperProfileWithIDFA:idfaString withOptions:0 withLimit:limit completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        completionHandler(profile, error);
        
    }];
    
}

-(NSString*)urlEncode:(NSString*)originalString {
    
    NSMutableCharacterSet* charsToEncode = [NSMutableCharacterSet characterSetWithCharactersInString:@"`=[]\\;#%^&+{}|\"<>?"];
    [charsToEncode invert];
    NSString* encodedStringWithSpaces = [originalString stringByAddingPercentEncodingWithAllowedCharacters:charsToEncode];
    return [encodedStringWithSpaces stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}
@end
