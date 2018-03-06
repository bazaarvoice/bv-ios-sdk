//
//  BVInclude.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BVIncludeTypeProtocol
+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue;
- (nonnull NSString *)toIncludeTypeParameterString;
@end

@interface BVInclude : NSObject

@property(nullable, strong, readonly) NSNumber *includeLimit;

- (nonnull id)initWithIncludeType:
    (nonnull id<BVIncludeTypeProtocol>)includeType;
- (nonnull id)initWithIncludeType:(nonnull id<BVIncludeTypeProtocol>)includeType
                     includeLimit:(nullable NSNumber *)includeLimit;
- (nonnull NSString *)toParameterString;

@end
