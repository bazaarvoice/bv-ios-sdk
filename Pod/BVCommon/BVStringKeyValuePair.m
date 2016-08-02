//
//  BVStringKeyValuePair.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStringKeyValuePair.h"

@implementation BVStringKeyValuePair

+(instancetype _Nonnull)pairWithKey:(NSString* _Nonnull)key value:(NSString* _Nullable)value {
    BVStringKeyValuePair* pair = [[BVStringKeyValuePair alloc] init];
    pair.key = key;
    pair.value = value;
    return pair;
}

@end
