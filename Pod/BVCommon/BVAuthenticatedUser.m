//
//  BVAuthenticatedUser.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVAnalyticsManager.h"
#import "BVAuthenticatedUser.h"
#import <AdSupport/AdSupport.h>

@interface BVAuthenticatedUser()

@property NSDate* previousUpdateDate;
@property NSDictionary* personalizedPreferences;

@end

@implementation BVAuthenticatedUser

-(void)updateProfile:(bool)force withAPIKey:(NSString *)passKey isStaging:(BOOL)isStage {
    
    // don't grab profile if user has opted for limited ad targeting
    if(![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        return;
    }
    
    if(force || [self shouldUpdateProfile]){
        
        self.previousUpdateDate = [NSDate date];
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSString* adsPassKey = passKey;
        NSString* baseUrl = [self getProfileUrl:isStage];
        NSString* profileUrl = [NSString stringWithFormat:@"%@/magpie_idfa_%@?passkey=%@", baseUrl, idfa, adsPassKey];
        
        [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", profileUrl]];
        
        NSURLSessionDataTask *profileTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:profileUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
          
            // Completion
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse && httpResponse.statusCode < 300){
                
                // Success
                
                NSError *errorJson;
                NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: (%ld): %@", (long)httpResponse.statusCode, responseDict]];
                
                if([self.personalizedPreferences isEqualToDictionary:responseDict]){
                    return; // No update
                }
                
                NSString* message = [NSString stringWithFormat:@"Profile for current user (may take a few moments to update): %@", responseDict];
                [[BVLogger sharedLogger] info:message];
                
                self.personalizedPreferences = responseDict;
                
                // For internal testing
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:self];
                });
                
            } else {
                
                // Failure
                NSString *errString = [NSString stringWithFormat:@"ERROR: magpie response. HTTP Status(%ld) with error: %@", (long)httpResponse.statusCode, error];
                [[BVLogger sharedLogger] error:errString];
                
                // For internal testing
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:nil];
                });
            }
            
        }];
        
        [profileTask resume];

    }
}

-(bool)shouldUpdateProfile {

    int profileLifeSeconds = 300;
    int timeSinceLastUpdate = [[NSDate date] timeIntervalSinceDate:self.previousUpdateDate];
    
    return self.previousUpdateDate == nil || timeSinceLastUpdate > profileLifeSeconds;
}

-(NSDictionary*)getTargetingKeywords {
    bool trackingEnabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    
    if(self.personalizedPreferences == nil || !trackingEnabled)
        return nil;
    
    NSDictionary* profile = [self.personalizedPreferences objectForKey:@"profile"];
    if(profile == nil){
        return nil;
    }
    
    NSMutableDictionary* targetingInfo = [NSMutableDictionary dictionary];
    
    for(NSString* key in profile) {
        // ensure we don't include profile id
        if([key isEqualToString:@"id"] == false){
            
            NSDictionary* value = [profile objectForKey:key];
            if(value != nil && [value count] > 0){
                [targetingInfo setObject:[self generateString:value] forKey:key];
            }
        }
    }
    
    return targetingInfo;
}

-(NSString*)generateString:(NSDictionary*)dict {
    NSMutableArray* keywords = [NSMutableArray array];
    for(NSString* key in [dict allKeys]){
        NSString* val = [dict objectForKey:key];
        [keywords addObject:[NSString stringWithFormat:@"%@_%@", key, val]];
    }
    
    return [keywords componentsJoinedByString:@" "];
}

-(NSString*)getProfileUrl:(BOOL)isStaging {
    if(isStaging){
        return @"https://dev.api.bazaarvoice.com/shopper/users";
    }
    else {
        return @"https://api.bazaarvoice.com/shopper/users";
    }
}

@end
