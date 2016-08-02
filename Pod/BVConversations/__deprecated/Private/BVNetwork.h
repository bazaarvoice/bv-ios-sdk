//
//  BVNetwork.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BVDelegate.h"
#import "BVCore.h"

__deprecated_msg("BVNetwork has been deprecated and will be removed in a future release. Please see the github documentation for recommended use of this SDK.")
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
