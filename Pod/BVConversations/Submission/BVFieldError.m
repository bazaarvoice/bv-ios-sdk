//
//  FieldError.m
//  
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFieldError.h"
#import "BVNullHelper.h"
#import "BVCore.h"

NSString* _Nonnull const BVFieldErrorName = @"BVFieldErrorName";
NSString* _Nonnull const BVFieldErrorMessage = @"BVFieldErrorMessage";
NSString* _Nonnull const BVFieldErrorCode = @"BVFieldErrorCode";

@implementation BVFieldError

-(nullable instancetype)initWithApiResponse:(nonnull NSDictionary*)apiResponse {
    self = [super init];
    if (self) {
        SET_IF_NOT_NULL(self.fieldName, apiResponse[@"Field"])
        SET_IF_NOT_NULL(self.message, apiResponse[@"Message"])
        SET_IF_NOT_NULL(self.code, apiResponse[@"Code"])
    }
    return self;
}


-(nonnull NSError*)toNSError {
    return [NSError errorWithDomain:BVErrDomain code:BV_ERROR_FIELD_INVALID userInfo:@{
                                                                       NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@: %@: %@", self.fieldName, self.code, self.message],
                                                                       BVFieldErrorName: self.fieldName,
                                                                       BVFieldErrorMessage: self.message,
                                                                       BVFieldErrorCode: self.code
                                                                    }];
}

+(nonnull NSArray<BVFieldError*>*)createListFromFormErrorsDictionary:(nullable id)apiResponse {
    
    if (apiResponse == nil || ![apiResponse isKindOfClass:[NSDictionary class]]) {
        return @[];
    }
    
    NSDictionary* apiObject = apiResponse;
    
    NSMutableArray<BVFieldError*>* results = [NSMutableArray array];
    NSDictionary* rawFieldErrors = apiObject[@"FieldErrors"];

    for (NSString* key in rawFieldErrors){
        NSDictionary* rawFieldError = rawFieldErrors[key];
        
        BVFieldError* fieldError = [[BVFieldError alloc] initWithApiResponse:rawFieldError];
        if (fieldError) {
            [results addObject:fieldError];
        }
    }
    
    return results;
}

@end
