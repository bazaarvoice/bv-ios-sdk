//
//  BVNetwork.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BVDelegate.h"

#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V2210"

@interface BVNetwork : NSObject<NSURLSessionDataDelegate>

- (id)initWithSender:(id)sender;

@property (weak) id<BVDelegate> delegate;
@property (strong) id sender;

- (void)setUrlParameterWithName:(NSString *)name value:(id)value;
- (void)setUrlListParameterWithName:(NSString *)name value:(NSString *)value;
- (void)addUrlParameterWithName:(NSString *)name value:(NSString *)value;
- (void)addNthUrlParameterWithName:(NSString *)name value:(NSString *)value;

- (void)sendGetWithEndpoint:(NSString *)endpoint;
- (void)sendGetWithEndpoint:(NSString *)endpoint withUrlString:(NSString *)urlString;
- (void)sendPostWithEndpoint:(NSString *)endpoint;
- (void)sendMultipartPostWithEndpoint:(NSString *)endpoint;

@end
