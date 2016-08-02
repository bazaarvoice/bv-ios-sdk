//
//  CommaUtil.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Internal utility - used only within BVSDK
@interface BVCommaUtil : NSObject

+(NSString* _Nonnull)escape:(NSString* _Nonnull)productId;
+(NSArray<NSString*>* _Nonnull)escapeMultiple:(NSArray<NSString*>* _Nonnull)productIds;

@end
