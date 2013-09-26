//
//  GCOAuth2.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "AFHTTPClient.h"

typedef enum {
    GCLoginTypeFacebook,
    GCLoginTypeInstagram,
    GCLoginTypeSkydrive,
    GCLoginTypeGoogle,
    GCLoginTypeFlickr,
    GCLoginTypeTwitter,
    GCLoginTypeChute,
    GCLoginTypeFoursquare,
    GCLoginTypeDropbox,
} GCLoginType;

@interface GCOAuth2Client : AFHTTPClient {
    NSString *clientID;
    NSString *clientSecret;
    NSString *redirectURI;
    NSString *scope;
}

extern NSString * const kGCClientID;
extern NSString * const kGCClientSecret;
extern int const kGCLoginTypeCount;
extern NSString * const kGCLoginTypes[];

@property (strong, nonatomic) NSArray *gcServices;

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret;
+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI;
+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret scope:(NSString *)_scope;
+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI scope:(NSString *)_scope;

- (NSURLRequest *)requestAccessForLoginType:(GCLoginType)loginType;
- (void)verifyAuthorizationWithAccessCode:(NSString *)code success:(void(^)(void))success failure:(void(^)(NSError *error))failure;

@end
