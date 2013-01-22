//
//  GCResponse.h
//
//  Created by Achal Aggarwal on 05/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCError.h"
#import "ASIHTTPRequest.h"
#import "GCJson.h"
#import "GCMacros.h"

@interface GCResponse : NSObject

@property (nonatomic, assign) NSUInteger statusCode;
@property (nonatomic, retain) GCError *error;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) id rawResponse;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) NSString *requestURL;

- (id) initWithRequest:(ASIHTTPRequest *) request;
- (BOOL) isSuccessful;

@end
