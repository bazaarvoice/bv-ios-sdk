//
//  BVSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVSubmission.h"
#import "BVLogger.h"

@implementation BVSubmission

-(void)sendError:(nonnull NSError*)error failureCallback:(ConversationsFailureHandler) failure {
    [[BVLogger sharedLogger] printError:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(@[error]);
    });
}

-(void)sendErrors:(nonnull NSArray<NSError*>*)errors failureCallback:(ConversationsFailureHandler) failure {
    for (NSError* error in errors) {
        [[BVLogger sharedLogger] printError:error];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(errors);
    });
}

@end
