//
//  GCRequest.m
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "GCAccount.h"

@implementation GCRequest

- (NSMutableDictionary *)headers{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            kDEVICE_NAME, @"x-device-name",
//            kUDID, @"x-device-identifier",
            kDEVICE_OS, @"x-device-os",
            kDEVICE_VERSION, @"x-device-version",
            kOAuthAppID, @"x-client_id",
            [NSString stringWithFormat:@"OAuth %@", [[GCAccount sharedManager] accessToken]], @"Authorization",
            nil];
}

- (GCResponse *)getRequestWithPath:(NSString *)path {
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];    
    [_request setRequestHeaders:[self headers]];
    [_request setTimeOutSeconds:300.0];
    [_request startSynchronous];
    GCResponse *_result = [[[GCResponse alloc] initWithRequest:_request] autorelease];
    return _result;
}

- (GCResponse *)postRequestWithPath:(NSString *)path
                          andParams:(NSMutableDictionary *)params
                          andMethod:(NSString *)method {
    
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:path]];
    [_request setRequestHeaders:[self headers]];
    if(params){
        if ([params objectForKey:@"headers"]) {
            NSDictionary *headers = [params objectForKey:@"headers"];
            for (id key in [headers allKeys]){
                [_request addRequestHeader:key value:[headers objectForKey:key]];
            }
            [params removeObjectForKey:@"headers"];
        }
        if ([params objectForKey:@"raw"]) {
            NSMutableData *data = [NSMutableData dataWithData:[params objectForKey:@"raw"]];
            [_request setPostBody:data];
        }
        else {
            [_request setPostBody:nil];
            for (id key in [params allKeys]) {
                [_request setPostValue:[params objectForKey:key] forKey:key];
            }
        }
    }
    [_request setTimeOutSeconds:300.0];
    [_request setRequestMethod:method];
    [_request startSynchronous];
    NSLog(@"POST BODY: %@",[_request postBody]);
    
    GCResponse *_result = [[[GCResponse alloc] initWithRequest:_request] autorelease];
    return _result;
}

- (GCResponse *)postRequestWithPath:(NSString *)path
                          andParams:(NSMutableDictionary *)params {
    return [self postRequestWithPath:path andParams:params andMethod:@"POST"];
}

- (GCResponse *)putRequestWithPath:(NSString *)path
                         andParams:(NSMutableDictionary *)params {
    return [self postRequestWithPath:path andParams:params andMethod:@"PUT"];
}

- (GCResponse *)deleteRequestWithPath:(NSString *)path
                            andParams:(NSMutableDictionary *)params {
    return [self postRequestWithPath:path andParams:params andMethod:@"DELETE"];
}

#pragma mark - Background Method Calls

- (void)getRequestInBackgroundWithPath:(NSString *)path
                          withResponse:(GCResponseBlock)aResponseBlock {
    DO_IN_BACKGROUND([self getRequestWithPath:path], aResponseBlock);
}

- (void)postRequestInBackgroundWithPath:(NSString *)path
                              andParams:(NSMutableDictionary *)params
                           withResponse:(GCResponseBlock)aResponseBlock {
    DO_IN_BACKGROUND([self postRequestWithPath:path andParams:params], aResponseBlock);
}

- (void)putRequestInBackgroundWithPath:(NSString *)path
                             andParams:(NSMutableDictionary *)params
                          withResponse:(GCResponseBlock)aResponseBlock {
    DO_IN_BACKGROUND([self putRequestWithPath:path andParams:params], aResponseBlock);
}

- (void)deleteRequestInBackgroundWithPath:(NSString *)path
                                andParams:(NSMutableDictionary *)params
                             withResponse:(GCResponseBlock)aResponseBlock {
    DO_IN_BACKGROUND([self deleteRequestWithPath:path andParams:params], aResponseBlock);
}

@end