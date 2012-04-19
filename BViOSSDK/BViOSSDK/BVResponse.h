//
//  BVResponse.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVResponse : NSObject

@property (strong) NSDictionary* includes;
@property (strong) NSDictionary* data;
@property (strong) NSDictionary* form;
@property (strong) NSDictionary* formErrors;
@property (strong) NSDictionary* field;
@property (strong) NSDictionary* group;
@property (strong) NSDictionary* subelements;
@property (strong) NSArray* results;
@property NSInteger offset;
@property NSInteger limit;
@property NSInteger totalResults;
@property NSInteger typicalHoursToPost;
@property (copy) NSString* locale;
@property BOOL hasErrors;
@property (strong) NSDictionary* errors;

// Store the contentType and the data in the content type
@property (strong) NSDictionary* contentData;
@property (copy) NSString* contentType;

// Raw response for debugging.
@property (nonatomic, copy) NSString* rawURLRequest;
@property (strong) NSDictionary* rawResponse;



@end