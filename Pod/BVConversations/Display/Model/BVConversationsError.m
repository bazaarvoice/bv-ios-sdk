//
//  ConversationsError.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsError.h"
#import "BVNullHelper.h"
#import "BVCore.h"

@implementation BVConversationsError

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse {
    self = [super init];
    if(self){
        SET_IF_NOT_NULL(self.message, apiResponse[@"Message"])
        SET_IF_NOT_NULL(self.code, apiResponse[@"Code"])
    }
    return self;
}

-(NSError* _Nonnull)toNSError {
    NSString* description = [NSString stringWithFormat:@"%@: %@", self.code, self.message];
    return [NSError
            errorWithDomain:BVErrDomain
            code:999
            userInfo:@{NSLocalizedDescriptionKey: description}];
}

+(NSArray<BVConversationsError*>* _Nonnull)createErrorListFromApiResponse:(id _Nullable)apiResponse {
    
    NSMutableArray<BVConversationsError*>* errors = [NSMutableArray array];
    
    if ([apiResponse isKindOfClass:[NSArray<NSDictionary*> class]]){
        NSArray<NSDictionary*>* apiObject = (NSArray<NSDictionary*>*)apiResponse;
        
        for (NSDictionary* errorDict in apiObject){
            BVConversationsError* error = [[BVConversationsError alloc] initWithApiResponse:errorDict];
            [errors addObject:error];
        }
        
    }
    return errors;
}



@end
