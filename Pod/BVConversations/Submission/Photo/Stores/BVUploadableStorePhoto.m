//
//  BVUploadableStorePhoto.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVUploadableStorePhoto.h"
#import "BVConversationsRequest.h"
#import "BVSDKManager.h"
#import "BVSubmissionErrorResponse.h"

@interface BVUploadableStorePhoto()

@end

@implementation BVUploadableStorePhoto


- (NSString * _Nonnull)getPasskey{
    return [BVSDKManager sharedManager].apiKeyConversationsStores;
}

@end
