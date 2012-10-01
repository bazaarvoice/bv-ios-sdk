//
//  BVSettings.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVSettings.h"

static BVSettings* BVSettingsSingleton = nil;

@implementation BVSettings
@synthesize passKey = _passKey, apiVersion = _apiVersion, customerName = _customerName;
@synthesize dataString = _dataString;
@synthesize formatString = _formatString;

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
        self.apiVersion = @"5.3";
        self.customerName = @"reviews.apitestcustomer.bazaarvoice.com";
        self.dataString = @"bvstaging/data";
        self.formatString = @"json";
	}
	return self;
}

- (void)dealloc {
    // Set to nil because unsafe_unretained does not zero out pointers.
    self.passKey = nil;
    self.apiVersion = nil;
    self.customerName = nil;
    self.dataString = nil;
    self.formatString = nil;
}

- (NSString *)description {
    NSString *returnValue = [NSString stringWithFormat:@"Setting Values:\n passKey = %@ \n apiVersion = %@ \n customerName = %@ \n dataString = %@ \n formatString = %@" , self.passKey, self.apiVersion, self.customerName, self.dataString, self.formatString];
    
    return returnValue;
}

@end