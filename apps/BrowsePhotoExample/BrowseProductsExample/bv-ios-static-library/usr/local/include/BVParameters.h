//
//  BVParameters.h
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/23/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


/*!BVParametersType encapsulates a generic additional parameter to a request of the form [prefixName]_[typeName] = [typeValue]. 
 
 For example, BVParameter type might represent a paramteter to filter, sort, or limit nested content. Consider the case where we wish to pass a parameter Limit_Comments = 20, which would limit the number of nested comments included in the response to 20. There are 3 components to this parameter; the prefix (“Limit”), type (“Comments”), and the value (20). These values correspond to the 3 properties declared in BVParametersType.
 */
@interface BVParametersType : NSObject


/*!
 The prefix name of the constraint to apply.  For instance, "Limit", "Filter" or "Sort".
 */
@property (nonatomic, copy) NSString* prefixName;
/*!
 The type of the nested content upon which to apply this constraint.  For instance, "Comments" or "Reviews".
 */
@property (nonatomic, copy) NSString* typeName;
/*!
 The value for this limit, filter or sort.
 */
@property (nonatomic, copy) NSString* typeValue;

// NSDictionary key-value list of the parameters encapsulated by this object.
- (NSDictionary*) dictionaryEntry;

@end

/*!
BVParameters encapsulates the parameters that are common to all API requests.  It is a base class that is subclassed to add additional parameters specific to a particular API call.
 */
@interface BVParameters : NSObject


/*!
 Related subjects to be included (e.g. Products, Categories, Authors, or Comments).
 */
@property (nonatomic, copy) NSString* include;
/*!
 Filter criteria for primary content of the query. Multiple filter criteria are supported.
 */
@property (nonatomic, copy) NSString* filter;
/*!
 Filtering option for included nested content. TYPE can be any included nested content. i.e. Comments for Reviews.  See BVParametersType.
 */
@property (nonatomic, strong) BVParametersType* filterType;
/*!
 Sort criteria for primary content type of the query. Sort order is required (asc or desc). Multi-attribute sorting for each content/subject type is supported.
 */
@property (nonatomic, copy) NSString* sort;
/*!
 Sorting option for nested content. Sort order is required (asc or desc). TYPE can be any nested content. i.e. Comments for Reviews.  See BVParametersType.
 */
@property (nonatomic, strong) BVParametersType* sortType;
/*! 
 Search term to query.  This is an "or" search.  For example, when querying for products with the search term "Electric Dryer," the result returns products that have both "Electric" and "Dryer" in the Product Name or Product Description.
 */
@property (nonatomic, copy) NSString* search;
/*!
 Index at which to return results. By default, indexing begins at 0 when you issue a query. Using Limit=100, Offset=0 returns results 0-99. When changing this to Offset=1, results 1-100 are returned.
 */
@property (nonatomic, copy) NSString* offset;
/*!
 Max number of records returned. An error is returned if the value passed exceeds 100.
 */
@property (nonatomic, copy) NSString* limit;
/*!
 Limit option for the nested content type returned. type can be any related content i.e.Reviews, Questions, Answers, Stories, Comments, Authors, Categories. An error is returned if the value passed exceeds 20.
 */
@property (nonatomic, strong) BVParametersType* limitType;
/*!
 User can provide a callback function name and the resultant JSON response will be wrapped inside that method call.  See http://developer.bazaarvoice.com/api/basics.
 */
@property (nonatomic, copy) NSString* callback;
/*!
 The content types for which statistics should be calculated for the product. Available content types are: Reviews, Questions, Answers, Stories. Note: Statistics can also be calculated on includes.
 */
@property (nonatomic, copy) NSString* stats;

// Get a dictionary of values that were set.
@property (nonatomic, readonly) NSDictionary* dictionaryOfValues;

@end