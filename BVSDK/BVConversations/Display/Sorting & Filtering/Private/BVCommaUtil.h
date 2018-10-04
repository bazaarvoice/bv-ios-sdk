//
//  CommaUtil.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVCommaUtil : NSObject

+ (nonnull NSString *)escape:(nonnull NSString *)productId;
+ (nonnull NSArray<NSString *> *)escapeMultiple:
    (nonnull NSArray<NSString *> *)productIds;

@end
