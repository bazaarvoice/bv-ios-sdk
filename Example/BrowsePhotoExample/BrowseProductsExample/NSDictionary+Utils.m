//
//  NSDictionary+Utils.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//
//
//  This category allows for graceful handling of null values in an NSDictionary
//  when parsing JSON.  For example:
// 
//  UITextLabel *myLabel.text = [myDictionary objectForKey:@"nullKey"];
//
//  will crash, whereas:
//
//  UITextLabel *myLabel.text = [myDictionary objectForKeyNotNull:@"nullKey"];
//
//  will display nothing.

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    return object;
}

@end
