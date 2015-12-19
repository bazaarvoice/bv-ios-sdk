//
//  NSDictionary+Utils.m
//  Bazaarvoice SDK - Photo Upload Example Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    return object;
}

@end
