//
//  CommaUtil.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVCommaUtil.h"

@implementation BVCommaUtil

+(NSString* _Nonnull)escape:(NSString* _Nonnull)productId {
    
    return [[[productId stringByReplacingOccurrencesOfString:@"," withString:@"\\,"]
                        stringByReplacingOccurrencesOfString:@":" withString:@"\\:"]
                        stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    
}

+(NSArray<NSString*>* _Nonnull)escapeMultiple:(NSArray<NSString*>* _Nonnull)productIds {
    
    NSMutableArray<NSString*>* results = [NSMutableArray array];
    for(NSString* productId in productIds) {
        [results addObject:[self escape:productId]];
    }
    return results;
    
}

@end
