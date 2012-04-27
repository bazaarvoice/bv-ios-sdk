//
//  BVParameters.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/23/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

//  A class to store all the parameters

#import <Foundation/Foundation.h>

@interface BVParametersType : NSObject

@property (nonatomic, copy) NSString* prefixName;
@property (nonatomic, copy) NSString* typeName;
@property (nonatomic, copy) NSString* typeValue;

- (NSDictionary*) dictionaryEntry;

@end

@interface BVParameters : NSObject

@property (nonatomic, copy) NSString* include;
@property (nonatomic, copy) NSString* filter;
@property (nonatomic, strong) BVParametersType* filterType;
@property (nonatomic, copy) NSString* sort;
@property (nonatomic, strong) BVParametersType* sortType;
@property (nonatomic, copy) NSString* search;
@property (nonatomic, copy) NSString* offset;
@property (nonatomic, copy) NSString* limit;
@property (nonatomic, strong) BVParametersType* limitType;
@property (nonatomic, copy) NSString* callback;
@property (nonatomic, copy) NSString* stats;

// Get a dictionary of values that were set.
@property (nonatomic, readonly) NSDictionary* dictionaryOfValues;

@end