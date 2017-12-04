//
//  Include.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "PDPContentType.h"
#import <Foundation/Foundation.h>

/// Internal class - used only within BVSDK
@interface PDPInclude : NSObject

@property PDPContentType type;
@property(nullable) NSNumber *limit;

- (nonnull id)initWithContentType:(PDPContentType)type
                            limit:(nullable NSNumber *)limit;
- (nonnull NSString *)toParamString;

@end
