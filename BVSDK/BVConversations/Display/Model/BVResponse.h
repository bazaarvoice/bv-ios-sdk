//
//  Response.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

/// Internal protocol - used only within BVSDK
@protocol BVResponse

- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
