//
//  BVConversionEvent.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVConversionEvent.h"
#import "BVAnalyticEventManager.h"

@implementation BVConversionEvent

@synthesize additionalParams;

-(id _Nonnull)initWithType:(NSString* _Nonnull)type value:(NSString* _Nonnull)value label:(NSString* _Nullable)label otherParams:(NSDictionary* _Nullable)params{
    self = [super initWithParams:params];
    
    NSAssert(type && type.length > 0, @"You must provide a type");
    NSAssert(value && value.length > 0, @"You must provide a value");
    
    if (self) {
        
        _type = type;
        _value = value;
        _label = label;
        self.additionalParams = params ? params : [NSDictionary dictionary];
    }
    
    return self;
}


- (NSDictionary *)toRaw{
    
    NSMutableDictionary *eventDict;
    
    if ([self hasPII]){
        eventDict = [self crateBaseEvent:YES];
        [eventDict addEntriesFromDictionary:CONVERSION_SCHEMA_PII];
        [eventDict setObject:@"true" forKey:@"hadPII"];
    } else {
        eventDict = [self crateBaseEvent:NO];
        [eventDict addEntriesFromDictionary:CONVERSION_SCHEMA];
    }
    
    [eventDict addEntriesFromDictionary:self.additionalParams];
    
    return [NSDictionary dictionaryWithDictionary:eventDict];
}

- (NSDictionary *)toRawNonPII {
    
    NSMutableDictionary *eventDict = [self crateBaseEvent:NO];
    
    if ([self hasPII]){
        [eventDict setObject:@"true" forKey:@"hadPII"];
    }
    
    NSDictionary *nonPIIParams = [self getNonPII:self.additionalParams]; // strip out any non-whitelisted params that may contain personal identifiers
    
    [eventDict addEntriesFromDictionary:nonPIIParams];
    
    return [NSDictionary dictionaryWithDictionary:eventDict];
    
}


- (NSMutableDictionary *)crateBaseEvent:(BOOL)anonymous {
    
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self.type, @"type",
                                      self.value, @"value",
                                      nil];
    
    // Add nullable values
    if (self.label) {
        [eventDict setObject:self.label forKey:@"label"];
    }
    
    // Common event values implied for schema...
    [eventDict setObject:[self getLoadId] forKey:@"loadId"];
    [eventDict addEntriesFromDictionary: [[BVAnalyticEventManager sharedManager] getCommonAnalyticsDictAnonymous:anonymous]];
    
    return eventDict;
    
}

@end
