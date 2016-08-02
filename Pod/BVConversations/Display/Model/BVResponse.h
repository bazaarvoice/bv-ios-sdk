//
//  Response.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

/// Internal protocol - used only within BVSDK
@protocol BVResponse

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

@end
