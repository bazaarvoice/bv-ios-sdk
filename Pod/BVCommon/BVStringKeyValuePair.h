//
//  BVStringKeyValuePair.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVStringKeyValuePair : NSObject

@property(nonnull) NSString *key;
@property(nullable) NSString *value;
+ (nonnull instancetype)pairWithKey:(nonnull NSString *)key
                              value:(nullable NSString *)value;

@end
