//
//  ConversationsErrorResponse.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsErrorResponse.h"
#import "BVConversationsError.h"

@interface BVConversationsErrorResponse()

@property NSArray<BVConversationsError*>* _Nonnull errors;

@end

@implementation BVConversationsErrorResponse

-(id _Nullable)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse {
    
    self = [super init];
    if(self){
    
        if([[apiResponse objectForKey:@"Errors"] isKindOfClass:[NSArray<NSDictionary*> class]]) {
            NSArray<NSDictionary*>* rawErrors = [apiResponse objectForKey:@"Errors"];
            
            NSMutableArray* errorsArrayBuilder = [NSMutableArray array];
            for(NSDictionary* rawError in rawErrors) {
                BVConversationsError* conversationsError = [[BVConversationsError alloc] initWithApiResponse:rawError];
                [errorsArrayBuilder addObject:conversationsError];
            }
            
            if ([errorsArrayBuilder count] == 0) {
                return nil;
            }
            
            self.errors = errorsArrayBuilder;
            
        }
        else {
            return nil;
        }
    }
    return self;
    
}

-(NSArray<NSError*>* _Nonnull)toNSErrors {
    
    NSMutableArray* nsErrorsBuilder = [NSMutableArray array];
    
    for (BVConversationsError* conversationsError in self.errors) {
        NSError* nsError = [conversationsError toNSError];
        [nsErrorsBuilder addObject:nsError];
    }
    
    return nsErrorsBuilder;
    
}

@end