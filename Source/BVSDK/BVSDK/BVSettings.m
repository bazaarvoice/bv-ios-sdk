//
//  BVSettings.m
//  BazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSettings.h"

static BVSettings* BVSettingsSingleton = nil;

@implementation BVSettings
@synthesize passKey = _passKey;
@synthesize baseURL = _baseURL;
@synthesize staging = _staging;
@synthesize timeout = _timeOutMs;

+ (BVSettings*) instance {
    if (BVSettingsSingleton == nil)
        BVSettingsSingleton = [[BVSettings alloc] init];
    
    return BVSettingsSingleton;
}

- (id) init {
	self = [super init];
	if (self != nil) {
        // Initalization code here. PUt in reasonable defaults.
        self.passKey = @"kuy3zj9pr3n7i0wxajrzj04xo";
        self.baseURL = @"reviews.apitestcustomer.bazaarvoice.com";
        self.staging = NO;
        self.timeout = 60;
	}
	return self;
}

- (void)dealloc {
    // Set to nil because unsafe_unretained does not zero out pointers.
    self.passKey = nil;
    self.baseURL = nil;
}

- (NSString *)description {
    NSString *returnValue = [NSString stringWithFormat:@"Setting Values:\n passKey = %@ \n apiVersion = %@ \n baseURL = %@ \n staging = %i \n" , self.passKey, BV_API_VERSION, self.baseURL, self.staging];
    
    return returnValue;
}

@end