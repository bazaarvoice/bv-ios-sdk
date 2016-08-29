//
//  BVVisit.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVVisit.h"

@implementation BVVisit

-(id)initWithName:(NSString*)name address:(NSString*)address city:(NSString*)city state:(NSString*)state zipCode:(NSString*)zipCode storeId:(NSString*)storeId {
    self = [super init];
    
    if(self) {
        _name = name;
        _address = address;
        _city = city;
        _state = state;
        _zipCode = zipCode;
        _storeId = storeId;
    }
    
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"BVLocation:\nName: %@\nStore Id: %@\nAddress: %@\nCity:%@\nState:%@\nZip:%@", _name, _storeId,_address, _city, _state, _zipCode];
}
@end
