//
//  ConversationsError.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Internal class - used only within BVSDK
@interface BVConversationsError : NSObject

@property NSString* _Nonnull message;
@property NSString* _Nonnull code;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;
-(NSError* _Nonnull)toNSError;
+(NSArray<BVConversationsError*>* _Nonnull)createErrorListFromApiResponse:(id _Nullable)apiResponse;

@end
