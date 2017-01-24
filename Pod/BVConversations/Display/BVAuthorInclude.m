//
//  BVAuthorInclude.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorInclude.h"

@implementation BVAuthorInclude

-(id _Nonnull)initWithContentType:(BVAuthorContentType)type limit:(NSNumber* _Nullable)limit {
    self = [super init];
    if(self){
        self.type = type;
        self.limit = limit;
    }
    return self;
}

-(NSString* _Nonnull)toParamString {
    return [BVAuthorContentTypeUtil toString:self.type];
}

@end
