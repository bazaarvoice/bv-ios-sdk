//
//  BVFormField.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVFormField.h"
#import "BVNullHelper.h"
#import "BVFormFieldOptions.h"

@implementation BVFormField

- (id)initWithFormFieldDictionary:(NSDictionary *)fieldDictionary{
    
    self = [super init];
    
    if (self){
        
        _identifier = @"";
        _label = @"";
        _type = @"";
        _value = @"";
        _required = [NSNumber numberWithBool:NO];
        _isDefault = [NSNumber numberWithBool:NO];
        _minLength = [NSNumber numberWithInteger:0];
        _maxLength = [NSNumber numberWithInteger:0];
        
        SET_IF_NOT_NULL(_identifier, [fieldDictionary objectForKey:@"Id"]);
        SET_IF_NOT_NULL(_label, [fieldDictionary objectForKey:@"Label"]);
        SET_IF_NOT_NULL(_type, [fieldDictionary objectForKey:@"Type"]);
        SET_IF_NOT_NULL(_value, [fieldDictionary objectForKey:@"Value"]);
        
        if (!isObjectNilOrNull([fieldDictionary objectForKey:@"MinLength"])){
            _minLength = [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"MinLength"] integerValue]];
        }
        
        if (!isObjectNilOrNull([fieldDictionary objectForKey:@"MaxLength"])){
            _maxLength = [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"MaxLength"] integerValue]];
        }
        
        if (!isObjectNilOrNull([fieldDictionary objectForKey:@"Required"])){
            _required = [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"Required"] boolValue]];
        }
        
        if (!isObjectNilOrNull([fieldDictionary objectForKey:@"Default"])){
            _isDefault = [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"Default"] boolValue]];
        }
        
        NSMutableArray *tmpOptions = [NSMutableArray array];
        for (NSDictionary *optionsDict in [fieldDictionary objectForKey:@"Options"]){
            BVFormFieldOptions *fieldOptions = [[BVFormFieldOptions alloc] initWithOptionsDictionary:optionsDict];
            [tmpOptions addObject:fieldOptions];
        }
        
        _options = [NSArray arrayWithArray:tmpOptions];
        
    }
    return self;
    
}


@end
