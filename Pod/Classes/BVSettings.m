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

+ (BVSettings*) instance {
    if (BVSettingsSingleton == nil)
        BVSettingsSingleton = [[BVSettings alloc] init];
    
    return BVSettingsSingleton;
}

- (id) init {
	self = [super init];
	if (self != nil) {
        // Initalization code here. PUt in reasonable defaults.
        self.passKey = @"KEY_REMOVED";
        self.clientId = @"apitestcustomer";
        self.staging = NO;
        self.timeout = 60;
	}
	return self;
}

- (NSString *)description {
    NSString *returnValue = [NSString stringWithFormat:@"Setting Values:\n passKey = %@ \n apiVersion = %@ \n clientId = %@ \n staging = %i \n" , self.passKey, BV_API_VERSION, self.clientId, self.staging];
    
    return returnValue;
}

@end