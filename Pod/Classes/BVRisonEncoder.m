//
//  BVRisonEncoder.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import "BVRisonEncoder.h"

@implementation BVRisonEncoder

+(NSString*)urlEncode:(NSString*)originalString {
    
    NSMutableCharacterSet* charsToEncode = [NSMutableCharacterSet characterSetWithCharactersInString:@"`=[]\\;#%^&+{}|\"<>?"];
    [charsToEncode invert];
    NSString* encodedStringWithSpaces = [originalString stringByAddingPercentEncodingWithAllowedCharacters:charsToEncode];
    return [encodedStringWithSpaces stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+(NSString*)encode:(NSObject*)value {
    
    NSString* result = @"";
    
    if(value == nil || value == [NSNull null]) {
        result = @"!n";
    }
    else if ([value isKindOfClass:[NSString class]]) {
        result = [BVRisonEncoder formatString:(NSString*)value];
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        result = [BVRisonEncoder formatArray:(NSArray*)value];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        result = [BVRisonEncoder formatDictionary:(NSDictionary*)value];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber* number = (NSNumber*)value;
        NSString* type = [NSString stringWithCString:[number objCType] encoding:NSUTF8StringEncoding];
        
        if([type isEqualToString:@"c"] || [type isEqualToString:@"C"]){
            result = [number boolValue] ? @"!t" : @"!f";
        }
        else {
            result = [[number stringValue] stringByReplacingOccurrencesOfString:@"+" withString:@""];
        }
    }
    
    return result;
}

+(NSString*)formatDictionary:(NSDictionary*)dict {
    
    NSMutableString* resultString = [NSMutableString string];
    NSArray* allKeys = [dict allKeys];
    NSArray* sortedKeys = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    bool firstObject = true;
    
    for(NSString* key in sortedKeys) {
        
        NSObject* value = [dict objectForKey:key];
        if(firstObject == false) {
            [resultString appendString:@","];
        }
        firstObject = false;
        
        [resultString appendFormat:@"%@:%@", [BVRisonEncoder encode:key], [BVRisonEncoder encode:value]];
    }
    
    return [NSString stringWithFormat:@"(%@)", resultString];
}

+(NSString*)formatArray:(NSArray*)value {
    
    NSMutableArray* encodedObjects = [NSMutableArray array];
    
    for(NSObject* item in value) {
        [encodedObjects addObject:[BVRisonEncoder encode:item]];
    }
    
    NSString* finalValue = [encodedObjects componentsJoinedByString:@","];
    return [NSString stringWithFormat:@"!(%@)", finalValue];
}

+(NSString*)formatString:(NSString*)value {
    
    if([value isEqualToString:@""]) {
        return @"''";
    }
    
    if([BVRisonEncoder isValidSimpleId:value]) {
        return value;
    }
    
    NSString* escaped1 = [value    stringByReplacingOccurrencesOfString:@"!" withString:@"!!"];
    NSString* escaped2 = [escaped1 stringByReplacingOccurrencesOfString:@"'" withString:@"!'"];
    
    return [NSString stringWithFormat:@"'%@'", escaped2];
}

+(bool)isValidSimpleId:(NSString*)value {
    NSRange range = [value rangeOfString:@"^([0-9]|-)|\\'|\\ |\\!|\\:|\\(|\\)|\\,|\\*|\\@|\\$" options:NSRegularExpressionSearch];
    
    if(range.location == NSNotFound) {
        return true;
    }
    else {
        return false;
    }
}

@end
