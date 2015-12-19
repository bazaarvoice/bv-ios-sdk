//
//  GCOAuth2.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCOAuth2Client.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+QueryString.h"
#import "GCClient.h"

static NSString * const kGCBaseURLString = @"https://getchute.com";

static NSString * const kGCScope = @"scope";
static NSString * const kGCScopeDefaultValue = @"all_resources manage_resources profile resources";
static NSString * const kGCType = @"type";
static NSString * const kGCTypeValue = @"web_server";
static NSString * const kGCResponseType = @"response_type";
static NSString * const kGCResponseTypeValue = @"code";
static NSString * const kGCRedirectURI = @"redirect_uri";
static NSString * const kGCRedirectURIDefaultValue = @"http://getchute.com/oauth/callback";

static NSString * const kGCOAuth = @"oauth";

NSString * const kGCLoginTypes[] = {
    @"facebook",
    @"instagram",
    @"microsoft_account",
    @"google",
    @"flickr",
    @"twitter",
    @"chute",
    @"foursquare",
    @"dropbox"
};

int const kGCLoginTypeCount = 9;

NSString * const kGCClientID = @"client_id";
NSString * const kGCClientSecret = @"client_secret";
NSString * const kGCCode = @"code";
NSString * const kGCGrantType = @"grant_type";
NSString * const kGCGrantTypeValue = @"authorization_code";

@implementation GCOAuth2Client

+ (instancetype)clientWithBaseURL:(NSURL *)url {
    NSAssert(NO, @"GCOAuth2Client instance cannot be generated with this method.");
    return nil;
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret {
    return [self clientWithClientID:_clientID clientSecret:_clientSecret redirectURI:kGCRedirectURIDefaultValue scope:kGCScopeDefaultValue];
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI {
    return [self clientWithClientID:_clientID clientSecret:_clientSecret redirectURI:_redirectURI scope:kGCScopeDefaultValue];
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret scope:(NSString *)_scope {
    return [self clientWithClientID:_clientID clientSecret:_clientSecret redirectURI:kGCRedirectURIDefaultValue scope:_scope];
}

+ (instancetype)clientWithClientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI scope:(NSString *)_scope {
    return [[GCOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:kGCBaseURLString] clientID:_clientID clientSecret:_clientSecret redirectURI:_redirectURI scope:_scope];
}

- (id)initWithBaseURL:(NSURL *)url clientID:(NSString *)_clientID clientSecret:(NSString *)_clientSecret redirectURI:(NSString *)_redirectURI scope:(NSString *)_scope {
    
    NSParameterAssert(_clientID);
    NSParameterAssert(_clientSecret);
    NSParameterAssert(_redirectURI);
    NSParameterAssert(_scope);
    
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    clientID = _clientID;
    clientSecret = _clientSecret;
    redirectURI = _redirectURI;
    scope = _scope;
    
//    [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status == AFNetworkReachabilityStatusNotReachable) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Internet connection detected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    return self;
}

- (void)verifyAuthorizationWithAccessCode:(NSString *)code success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSDictionary *params = @{
                             kGCClientID:clientID,
                             kGCClientSecret:clientSecret,
                             kGCRedirectURI:redirectURI,
                             kGCCode:code,
                             kGCGrantType:kGCGrantTypeValue,
                             };
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"oauth/token" parameters:params];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){

        [apiClient setAuthorizationHeaderWithToken:[JSON objectForKey:@"access_token"]];
        success();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error);
    }];
    
    [operation start];
}

- (NSURLRequest *)requestAccessForLoginType:(GCLoginType)loginType {
    
    NSDictionary *params = @{
                             kGCScope:@"",
                             kGCResponseType:kGCResponseTypeValue,
                             kGCClientID:clientID,
                             kGCRedirectURI:kGCRedirectURIDefaultValue,
                             };

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://getchute.com/v2/oauth/%@/authorize?%@",
                                                                               kGCLoginTypes[loginType],
                                                                               [params stringWithFormEncodedComponents]]]];
//    [self clearCookiesForLoginType:loginType];
    NSLog(@"Request description:%@",[request description]);
    return request;
}

/* This method clears cookies for specific loginType. It can and should be used in applications with logout option. In that
    way you give option to a user to login on same service (of the same type) with a different account.*/
- (void)clearCookiesForLoginType:(GCLoginType)loginType {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[storage cookies] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSHTTPCookie *cookie = obj;
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:kGCLoginTypes[loginType]];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }];
}

@end
