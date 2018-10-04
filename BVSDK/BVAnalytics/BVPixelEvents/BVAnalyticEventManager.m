//
//  BVAnalyticEventManager.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>

#import "BVAnalyticEventManager+Private.h"

#define BVID_STORAGE_KEY @"BVID_STORAGE_KEY"

@interface BVAnalyticEventManager ()
@property(strong, nonatomic) NSString *BVID;
@property(strong, nonatomic) dispatch_queue_t ivarQueue;
@end

@implementation BVAnalyticEventManager

@synthesize clientId = _clientId;
@synthesize eventSource = _eventSource;

__strong static BVAnalyticEventManager *mgrInstance = nil;

+ (BVAnalyticEventManager *)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mgrInstance = [[self alloc] init];
  });

  return mgrInstance;
}

- (void)setClientId:(NSString *)clientId {
  /*
   * We make this sticky to protect against client toggles, i.e., you can
   * never set this to "nil". It alwaays retains the previous client id.
   */
  if (clientId) {
    dispatch_sync(self.ivarQueue, ^{
      self->_clientId = clientId;
    });
  }
}

- (NSString *)clientId {
  __block NSString *blockClientId = nil;
  dispatch_sync(self.ivarQueue, ^{
    blockClientId = self->_clientId;
  });
  return blockClientId;
}

- (id)init {
  if ((self = [super init])) {
    self.ivarQueue = dispatch_queue_create(
        "com.bazaarvoice.BVAnalyticEventManager.ivarQueue",
        DISPATCH_QUEUE_SERIAL);
    self.eventSource = @"native-mobile-custom";
    self.BVID =
        [[NSUserDefaults standardUserDefaults] stringForKey:BVID_STORAGE_KEY];
    if (!self.BVID || 0 == [self.BVID length]) {
      self.BVID = [[NSUUID UUID] UUIDString];
      [[NSUserDefaults standardUserDefaults] setValue:self.BVID
                                               forKey:BVID_STORAGE_KEY];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
  }
  return self;
}

- (NSDictionary *)getCommonAnalyticsDictAnonymous:(BOOL)anonymous {
  NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
    @"mobileSource" : @"bv-ios-sdk",
    @"HashedIP" : @"default",
    @"source" : self.eventSource,
    @"UA" : self.BVID
  }];

  NSAssert(self.clientId, @"Client ID cannot be nil. The client ID is "
                          @"the Compnay name you use in the "
                          @"Bazaarvoice workbench.");

  [params setValue:self.clientId forKey:@"client"];

  // idfa
  // check it limit ad tracking is enabled
  NSString *idfa = @"nontracking";
#ifndef DISABLE_BVSDK_IDFA
  if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] &&
      !anonymous) {
    idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier]
        UUIDString];
  }
#endif

  [params setValue:idfa forKey:@"advertisingId"];

  return params;
}

@end
