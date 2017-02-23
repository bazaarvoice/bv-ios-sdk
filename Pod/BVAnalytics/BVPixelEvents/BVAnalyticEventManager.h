//
//  BVAnalyticEventManager.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVAnalyticEventManager : NSObject

+ (BVAnalyticEventManager *)sharedManager;

/// Sets the client ID to be used for all analytic events. Only set this if your client app does not use the BVSDKManager to initialize the SDK.
@property (strong, nonatomic) NSString *clientId;

// Internal use only
@property (strong, nonatomic) NSString *eventSource;

- (NSDictionary *)getCommonAnalyticsDictAnonymous:(BOOL)anonymous;


@end
