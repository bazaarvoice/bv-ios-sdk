//
//  BVUploadableStorePhoto.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVUploadableStorePhoto.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"

@interface BVUploadableStorePhoto ()
@end

@implementation BVUploadableStorePhoto

- (NSString *)conversationsKey {
  return [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
}

@end
