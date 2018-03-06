

//
//  BVFieldError.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorCode.h"
#import <Foundation/Foundation.h>

extern NSString *__nonnull const BVFieldErrorName;
extern NSString *__nonnull const BVFieldErrorMessage;
extern NSString *__nonnull const BVFieldErrorCode;

// Internal class - used only within BVSDK
@interface BVFieldError : NSObject

@property(nonnull) NSString *fieldName;
@property(nonnull) NSString *message;
@property(nonnull) NSString *code;

- (nullable instancetype)initWithApiResponse:
    (nonnull NSDictionary *)apiResponse;
- (nonnull NSError *)toNSError;
+ (nonnull NSArray<BVFieldError *> *)createListFromFormErrorsDictionary:
    (nullable id)apiResponse;

@end
