//
//  BVSubmission.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/27/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSubmission.h"
#import "SBJson.h"

@implementation BVSubmission
@synthesize parameters = _parameters;

- (id) init {
	self = [super init];
	if (self != nil) {
        // Initalization code here. Put in reasonable defaults.
	}
	return self;
}

- (void)dealloc {
    // Set to nil because unsafe_unretained does not zero out pointers.
}

- (NSMutableURLRequest*) generateURLRequestWithString:(NSString*)string {
    NSString *parameterString = [NSString stringWithFormat:@"apiversion=%@&passkey=%@", self.settingsObject.apiVersion, self.settingsObject.passKey];
    parameterString = [parameterString stringByAppendingString:[self parameterURL]];
    
    // Call super here so we send the SDK header.
    NSMutableURLRequest *request = [super generateURLRequestWithString:string];
    
    NSData *requestData = [NSData dataWithBytes:[parameterString UTF8String] length:[parameterString length]];
    NSLog(@"Parameters to be sent in POST body:%@", parameterString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    // Attach the SDK version header to every request.
    [request addValue:SDK_HEADER_VALUE forHTTPHeaderField:SDK_HEADER_NAME];
    
    return request;
}

- (NSString*) buildURLString {
    NSString *buildString = [NSString stringWithFormat:@"http://%@.%@/%@/", self.settingsObject.customerName, BAZAARVOICECOM, self.settingsObject.dataString];
    buildString = [buildString stringByAppendingFormat:@"%@.%@", self.displayType, self.settingsObject.formatString];
    return buildString;
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVSubmissionParametersBase alloc] init];
    return _parameters;
}

#pragma mark Overrides
- (NSString*) displayType {
    return @"Over Ride Here";
}


@end
