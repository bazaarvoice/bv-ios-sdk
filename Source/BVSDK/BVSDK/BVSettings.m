//
//  BVSettings.m
//  BazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//
//  Copyright 2013 Bazaarvoice, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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