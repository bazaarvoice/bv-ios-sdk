//
//  BVSettings.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import "BVSettings.h"
#import "BVAnalyticsManager.h"

static BVSettings* BVSettingsSingleton = nil;

@implementation BVSettings

+ (BVSettings *) instance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BVSettingsSingleton = [[self alloc] init];
    });
    
    return BVSettingsSingleton;
}

- (id) init {
	self = [super init];
	if (self != nil) {
        // Initalization code here. Passkey and client Id MUST be set by client or app will asssert!
        [BVSDKManager sharedManager];
	}
	return self;
}

- (NSString *)description {
    return [BVSDKManager sharedManager].description;
}

- (void)setPassKey:(NSString *)passKey{
    [BVSDKManager sharedManager].apiKeyConversations = passKey;
}

- (void)setClientId:(NSString *)clientId{
    [BVSDKManager sharedManager].clientId = clientId;
}

- (void)setStaging:(BOOL)staging{
    [BVSDKManager sharedManager].staging = staging;
}

-(void)setLogLevel:(BVLogLevel)logLevel {
    [[BVSDKManager sharedManager] setLogLevel:logLevel];
}


@end