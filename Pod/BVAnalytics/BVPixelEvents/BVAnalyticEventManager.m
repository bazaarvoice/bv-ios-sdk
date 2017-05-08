//
//  BVAnalyticEventManager.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>

#import "BVAnalyticEventManager.h"

#define BVID_STORAGE_KEY @"BVID_STORAGE_KEY"

@interface BVAnalyticEventManager ()

@property (strong, nonatomic) NSString *BVID;

@end

@implementation BVAnalyticEventManager

static BVAnalyticEventManager *mgrInstance = nil;

+ (BVAnalyticEventManager *) sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgrInstance = [[self alloc] init];
    });
    
    return mgrInstance;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        _eventSource = @"native-mobile-custom";
        self.BVID = [[NSUserDefaults standardUserDefaults] stringForKey:BVID_STORAGE_KEY];
        if(self.BVID == nil || [self.BVID length] == 0) {
            self.BVID = [[NSUUID UUID] UUIDString];
            [[NSUserDefaults standardUserDefaults] setValue:self.BVID forKey:BVID_STORAGE_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
    return self;
}


- (NSDictionary *)getCommonAnalyticsDictAnonymous:(BOOL)anonymous {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"mobileSource": @"bv-ios-sdk",
                                                                                  @"HashedIP" : @"default",
                                                                                  @"source" : self.eventSource,
                                                                                  @"UA" : self.BVID
                                                                                  }];
    
    NSAssert(self.clientId != nil, @"Client ID cannot be nil. The client ID is the Compnay name you use in the Bazaarvoice workbench.");
    
    [params setValue:self.clientId forKey:@"client"];
    
    // idfa
    //check it limit ad tracking is enabled
    NSString *idfa = @"nontracking";
#ifndef DISABLE_BVSDK_IDFA
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] && !anonymous){
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
#endif
    
    [params setValue:idfa forKey:@"advertisingId"];
    
    return params;
}


@end
