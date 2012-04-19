//
//  BVParameters.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/23/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVParameters.h"

@implementation BVParameters

@synthesize include             =   _include;
@synthesize filter              =   _filter;
@synthesize filterType          =   _filterType;
@synthesize sort                =   _sort;
@synthesize sortType            =   _sortType;
@synthesize search              =   _search;
@synthesize offset              =   _offset;
@synthesize limit               =   _limit;
@synthesize limitType           =   _limitType;
@synthesize callback            =   _callback;
@synthesize stats               =   _stats;

- (NSDictionary*) dictionaryOfValues {
    NSDictionary *returnDictionary = [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"include", @"filter", @"filterType"
                                                                        , @"sort", @"sortType", @"search", @"offset", @"limit", @"limitType"
                                                                        , @"callback", @"stats", nil]];
    
    NSMutableDictionary *BVParamDict = [[NSMutableDictionary alloc] init];
    [BVParamDict addEntriesFromDictionary:[self.filterType dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.sortType dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:[self.limitType dictionaryEntry]];
    [BVParamDict addEntriesFromDictionary:returnDictionary];
    
    returnDictionary = [NSDictionary dictionaryWithDictionary:BVParamDict]; // Return with the BVParams.
    return returnDictionary;
}

// Allocate memory for BVParametersType here.
- (BVParametersType*) filterType {
    // Lazy instationation...
    if (_filterType == nil) {
        _filterType = [[BVParametersType alloc] init];
        _filterType.prefixName = @"Filter";
    }
    
    return _filterType;
}

- (BVParametersType*) sortType {
    // Lazy instationation...
    if (_sortType == nil) {
        _sortType = [[BVParametersType alloc] init];
        _sortType.prefixName = @"Sort";
    }
    return _sortType;
}

- (BVParametersType*) limitType {
    // Lazy instationation...
    if (_limitType == nil) {
        _limitType = [[BVParametersType alloc] init];
        _limitType.prefixName = @"Limit";
    }
    
    return _limitType;
}

@end

@implementation BVParametersType

@synthesize typeName                = _typeName;
@synthesize typeValue               = _typeValue;
@synthesize prefixName              = _prefixName;

- (NSDictionary*) dictionaryEntry {
    NSString *keyConstructed;
    NSDictionary *returnDict = nil;

    if (self.typeValue) {
        keyConstructed = [NSString stringWithFormat:@"%@_%@", self.prefixName, self.typeName];
        returnDict = [NSDictionary dictionaryWithObject:self.typeValue forKey:keyConstructed];
    }
    
    return returnDict;
}

@end