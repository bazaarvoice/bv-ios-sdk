//
//  FieldError.h
//  
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* _Nonnull const BVFieldErrorName;
extern NSString* _Nonnull const BVFieldErrorMessage;
extern NSString* _Nonnull const BVFieldErrorCode;

// Internal class - used only within BVSDK
@interface BVFieldError : NSObject

@property NSString* _Nonnull fieldName;
@property NSString* _Nonnull message;
@property NSString* _Nonnull code;

-(nullable instancetype)initWithApiResponse:(nonnull NSDictionary*)apiResponse;
-(nonnull NSError*)toNSError;
+(nonnull NSArray<BVFieldError*>*)createListFromFormErrorsDictionary:(nullable id)apiResponse;

@end
