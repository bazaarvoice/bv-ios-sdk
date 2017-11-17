//
//  BVSubmittedUAS.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A successfully submitted user authenticated string.
@interface BVSubmittedUAS : NSObject

@property (readonly) NSString *_Nullable authenticatedUser;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
