//
//  BVConversion.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVConversion.h"

@implementation BVConversion

-(id _Nonnull)initWithType:(NSString* _Nonnull)type value:(NSString* _Nonnull)value label:(NSString* _Nullable)label otherParams:(NSDictionary* _Nullable)params{
    self = [super init];
    
    if (self) {
        _type = type;
        _value = value;
        _label = label;
        _otherParams = params;
    }
    
    return self;
}

@end
