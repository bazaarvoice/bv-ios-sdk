//
//  BVResponse.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVResponse.h"

@implementation BVResponse
@synthesize rawURLRequest               = _rawURLRequest;
@synthesize rawResponse                 = _rawResponse;
@synthesize includes                    = _includes;
@synthesize data                        = _data;
@synthesize form                        = _form;
@synthesize formErrors                  = _formErrors;
@synthesize field                       = _field;
@synthesize group                       = _group;
@synthesize subelements                 = _subelements;
@synthesize results                     = _results;
@synthesize offset                      = _offset;
@synthesize limit                       = _limit;
@synthesize totalResults                = _totalResults;
@synthesize typicalHoursToPost          = _typicalHoursToPost;
@synthesize locale                      = _locale;
@synthesize hasErrors                   = _hasErrors;
@synthesize errors                      = _errors;

@synthesize contentData                 = _contentData;
@synthesize contentType                 = _contentType;

- (id) init {
	self = [super init];
	if (self != nil) {
        // Initalization code here. Put in reasonable defaults.
        self.hasErrors = NO;
	}
	return self;
}

- (void)dealloc {
    // Set to nil because unsafe_unretained does not zero out pointers.
    self.rawResponse = nil;
}

- (NSString *)description {
    NSString *returnValue = @"BVResponse: \n";
    if (self.hasErrors) {
        returnValue = [returnValue stringByAppendingFormat:@"Has Errors: %@\n", [self.errors description]];
    }
    else {
        returnValue = [returnValue stringByAppendingFormat:@"Includes: %@\n", [self.includes description]];
        returnValue = [returnValue stringByAppendingFormat:@"Results: %@\n", [self.results description]];
        returnValue = [returnValue stringByAppendingFormat:@"Offset: %d\n", self.offset];
        returnValue = [returnValue stringByAppendingFormat:@"Limit: %d\n", self.limit];
        returnValue = [returnValue stringByAppendingFormat:@"Total Results: %d\n", self.totalResults];
        returnValue = [returnValue stringByAppendingFormat:@"Locale: %d\n", self.locale];
    }
    
    return returnValue;
}

@end