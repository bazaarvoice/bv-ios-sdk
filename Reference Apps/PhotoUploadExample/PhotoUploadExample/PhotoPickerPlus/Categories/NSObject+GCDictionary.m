//
//  NSManagedObject+RNDictionary.m
//  VisionBook
//
//  Created by Aleksandar Trpeski on 7/23/13.
//  Copyright (c) 2013 ARANEA. All rights reserved.
//

#import "NSObject+GCDictionary.h"
#import <objc/runtime.h>

@implementation NSObject (GCDictionary)

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *muteDictionary = [NSMutableDictionary dictionary];
    
    id YourClass = [self class];//objc_getClass("YOURCLASSNAME");
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(YourClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        SEL propertySelector = NSSelectorFromString(propertyName);
        if ([self respondsToSelector:propertySelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [muteDictionary setValue:[self performSelector:propertySelector] forKey:propertyName];
#pragma clang diagnostic pop
        }
    }
    return muteDictionary;
}

@end
