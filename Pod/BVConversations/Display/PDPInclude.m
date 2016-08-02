//
//  Include.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "PDPInclude.h"

@implementation PDPInclude

-(id _Nonnull)initWithContentType:(PDPContentType)type limit:(NSNumber* _Nullable)limit {
    self = [super init];
    if(self){
        self.type = type;
        self.limit = limit;
    }
    return self;
}

-(NSString* _Nonnull)toParamString {
    return [PDPContentTypeUtil toString:self.type];
}

@end
