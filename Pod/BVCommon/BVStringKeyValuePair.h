//
//  BVStringKeyValuePair.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVStringKeyValuePair : NSObject

@property NSString* _Nonnull key;
@property NSString* _Nullable value;
+(instancetype _Nonnull)pairWithKey:(NSString* _Nonnull)key value:(NSString* _Nullable)value;

@end
