//
//  BVUploadableStorePhoto.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVUploadableStorePhoto.h"
#import "BVConversationsRequest.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import "BVSubmissionErrorResponse.h"

@interface BVUploadableStorePhoto ()

@end

@implementation BVUploadableStorePhoto

- (nonnull NSString *)getPasskey {
  return [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
}

@end
