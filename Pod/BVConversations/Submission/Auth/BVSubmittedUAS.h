//
//  BVSubmittedUAS.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A successfully submitted user authenticated string.
@interface BVSubmittedUAS : NSObject

@property(nullable, readonly) NSString *authenticatedUser;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
