//
//  BVResponse.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

/*!
 BVResponse is a list of properties that correspond to the possible responses sent from the server. If no value for that property was sent, it is set to nil or 0 depending on the type.
 */

#import <Foundation/Foundation.h>

@interface BVResponse : NSObject


/*!
 Includes content if requested.  For example, a request for products might include associated reviews.
 */
@property (strong) NSDictionary* includes;
/*!
The data payload for the request containing the fields and field groups.
 */
@property (strong) NSDictionary* data;
/*
 Section containing an array of form field and group references.
 */
@property (strong) NSDictionary* form;
/*
 Form errors, if any.
 */
@property (strong) NSDictionary* formErrors;
@property (strong) NSDictionary* field;
@property (strong) NSDictionary* group;
/*
 Explicitly named subelements dictionary, if any.
 */
@property (strong) NSDictionary* subelements;
/*
 Explicitly named results array, if any.
 */
@property (strong) NSArray* results;
/* 
 Results offset if set.
 */
@property NSInteger offset;
/*
 Results limit if set.
 */
@property NSInteger limit;
/*!
 Total number of records matched.
 */
@property NSInteger totalResults;
/*!
 Usual time it takes for the content to get posted.
 */
@property NSInteger typicalHoursToPost;
/* 
 Locale to display Labels, Configuration, Product Attributes and Category Attributes in. The default value is the locale defined in the display associated with the API key. If specified, the locale value is also used as the default ContentLocale filter value.
 */
@property (copy) NSString* locale;
/*!
 Boolean indicating whether this request had any errors.
 */
@property BOOL hasErrors;
/*!
 NSDictionary of errors associated with this request, if any.
 */
@property (strong) NSDictionary* errors;

// Store the contentType and the data in the content type.
@property (strong) NSDictionary* contentData;

/*!
 Content type associated with this request.
 */
@property (copy) NSString* contentType;

/*!
 The original URL request.
 */
@property (nonatomic, copy) NSString* rawURLRequest;
/*!
 The raw response from the server, parsed from the returned JSON.
 */
@property (strong) NSDictionary* rawResponse;



@end