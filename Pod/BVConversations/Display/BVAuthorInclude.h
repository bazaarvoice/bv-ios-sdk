//
//  BVAuthorInclude.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorContentType.h"
#import <Foundation/Foundation.h>

@interface BVAuthorInclude : NSObject

@property BVAuthorContentType type;
@property(nullable) NSNumber *limit;

- (nonnull id)initWithContentType:(BVAuthorContentType)type
                            limit:(nullable NSNumber *)limit;
- (nonnull NSString *)toParamString;

@end
