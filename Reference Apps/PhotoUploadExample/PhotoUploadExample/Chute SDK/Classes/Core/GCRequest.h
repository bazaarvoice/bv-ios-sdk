//
//  GCRequest.h
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCMacros.h"
#import "GCConstants.h"
#import "ASIHTTPRequest.h"
#import "GCJson.h"
#import "GCResponse.h"
#import "GCError.h"

@interface GCRequest : NSObject

- (NSMutableDictionary *)headers;

- (GCResponse *)getRequestWithPath:(NSString *)path;

- (GCResponse *)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params;

- (GCResponse *)postRequestWithPath:(NSString *)path
                andParams:(NSMutableDictionary *)params
                andMethod:(NSString *)method;

- (GCResponse *)putRequestWithPath:(NSString *)path
                       andParams:(NSMutableDictionary *)params;

- (GCResponse *)deleteRequestWithPath:(NSString *)path
                          andParams:(NSMutableDictionary *)params;

//Background Calls
- (void)getRequestInBackgroundWithPath:(NSString *)path
                          withResponse:(GCResponseBlock)aResponseBlock;

- (void)postRequestInBackgroundWithPath:(NSString *)path
                              andParams:(NSMutableDictionary *)params
                           withResponse:(GCResponseBlock)aResponseBlock;

- (void)putRequestInBackgroundWithPath:(NSString *)path
                             andParams:(NSMutableDictionary *)params
                          withResponse:(GCResponseBlock)aResponseBlock;

- (void)deleteRequestInBackgroundWithPath:(NSString *)path
                                andParams:(NSMutableDictionary *)params
                             withResponse:(GCResponseBlock)aResponseBlock;
@end
