//
//  BVGet.h
//  BazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 11/26/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVConstants.h"
#import "BVDelegate.h"

/*!
 BVGet is used for all requests to the Bazaarvoice API which fetch, but do not modify data on the server.  This includes fetching answers, authors, categories, comments, products, questions, reviews, statistics and stories.
 
 In the simplest case, a request might be created as follows:
 
BVGet *getReviewsRequest = [[ BVGet  alloc ] initWithType:BVGetTypeReviews ];  <br/>
[ getReviewsRequest sendRequestWithDelegate:self ];
 
 The specified delegate will then receive BVDelegate callbacks when a response is received.  Note that it is the client's responsibility to set the delegate to nil in the case that the the delegate is deallocated before a response is received.
 */
@interface BVGet : NSObject

/*!
 Convenience initializer with type.
@param type The particular type (BVGetTypeReviews, BVGetTypeQuestions...) of this request.
 */
- (id)initWithType:(BVGetType)type;

/*!
 The particular type (BVGetTypeReviews, BVGetTypeQuestions...) of this request.
 */
@property (assign, nonatomic) BVGetType type;
/*!
 The client delegate to receive BVDelegate notifications.
 */
@property (weak) id<BVDelegate> delegate;

/*!
 The URL that this request was sent to.  Is only available after the request has been sent.
 */
@property (assign, nonatomic) NSString *requestURL;

/*!
 Search term to query.  This is an "or" search.  For example, when querying for products with the search term "Electric Dryer," the result returns products that have both "Electric" and "Dryer" in the Product Name or Product Description.
 */
@property (assign, nonatomic) NSString *search;
/*!
 Locale to display Labels, Configuration, Product Attributes and Category Attributes in. The default value is the locale defined in the display associated with the API key. If specified, the locale value is also used as the default ContentLocale filter value.
 */
@property (assign, nonatomic) NSString *locale;
/*!
 Limits the maximum number of results that may be returned.
 */
@property (assign, nonatomic) int limit;
/*!
 Changes the offset for returned results.
 */
@property (assign, nonatomic) int offset;
/*!
 Boolean flag indicating whether to exclude content (reviews, questions, etc.) from other products in the same family as the requested product. This setting only affects any nested content that is returned. For example, "&filter=productid:eq:1101&include=reviews&excludeFamily=true" limits returned review content to just that of product 1101 and not any of the products in the same family. If a value is not defined, content on all products in the family is returned. */
@property (assign, nonatomic) bool excludeFamily;

/*!
 Related subjects to be included (e.g. Products, Categories, Authors, Reviews...).
@param includeType Type to include.
 */
- (void)addInclude:(BVIncludeType)includeType;
/*!
Attributes to be included when returning content. For example, if includes are requested along with the &attributes=ModeratorCodes parameter, both the includes and the results will contain moderator codes. In order to filter by ModeratorCode, you must request the ModeratorCodes attribute parameter.
@param attribute Attribute to include.
 */
- (void)addAttribute:(NSString *)attribute;
/*!
 Sort criteria for primary content type of the query. Multi-attribute sorting for each content/subject type is supported.
 @param attribute The attribute upon which to sort.  Rating, for example.
 @param ascending Sort order - ascending if true, descending if false.
 */
- (void)addSortForAttribute:(NSString *)attribute ascending:(BOOL)ascending;
/*!
 Adds statistics which should be calculated for the request.
 @param type The content types for which statistics should be calculated. Note: Statistics can also be calculated on includes.
 */
- (void)addStatsOn:(BVIncludeStatsType)type;
/*!
 Search query for included content.  This is an "or" search and must include a type.  For example, when querying included products with the search term "Electric Dryer," the result returns products that have both "Electric" and "Dryer" in the Product Name or Product Description.
@param type The included type for which the search term applies.
@param search The search query.
 */
- (void)setSearchOnIncludedType:(BVIncludeType)type search:(NSString *)search;
/*!
 Sorting option for included content. 
 @param type The included type for which the sort applies.
 @param attribute The attribute upon which to sort.  Rating, for example.
 @param ascending Sort order - ascending if true, descending if false.
 */
- (void)addSortOnIncludedType:(BVIncludeType)type attribute:(NSString *)attribute ascending:(BOOL)ascending;
/*!
 Limit option for included content.
 @param type The included type for which the limit applies.
 @param value The limit to apply. An error is returned if the value passed exceeds 20.
 */
- (void)setLimitOnIncludedType:(BVIncludeType)type value:(int)value;
/*!
 Filter criteria for primary content of the query.
 @param attribute The attribute upon which to sort.  Rating, for example.
 @param equality The equality filter to apply - (equal, greater than, less than...)
 @param value The value to compare against.  For example, this might be @"3045" when filtering on review id 3045.
 */
- (void)setFilterForAttribute:(NSString *)attribute equality:(BVEquality)equality value:(NSString *)value;
/*!
 Filter criteria for primary content of the query where multiple comparison values are required.
 @param attribute The attribute upon which to sort.  Rating, for example.
 @param equality The equality filter to apply - (equal, greater than, less than...)
 @param values Array of values to compare against.  For example, this array might contain values @"3045", @"3046" and @"3047" when filtering on review ids 3045, 3046 and 3047.
 */
- (void)setFilterForAttribute:(NSString *)attribute equality:(BVEquality)equality values:(NSArray *)values;
/*!
 Filtering option for included content.
 @param type The included type for which the filter applies.
 @param attribute The attribute upon which to sort.  Rating, for example.
 @param equality The equality filter to apply - (equal, greater than, less than...)
 @param value The value to compare against.  For example, this might be @"3045" when filtering on review id 3045.
 */
- (void)setFilterOnIncludedType:(BVIncludeType)type
                   forAttribute:(NSString *)attribute
                       equality:(BVEquality)equality
                          value:(NSString *)value;
/*!
 Filtering option for included content.
 @param type The included type for which the filter applies.
 @param attribute The attribute upon which to sort.  Rating, for example.
 @param equality The equality filter to apply - (equal, greater than, less than...)
 @param values Array of values to compare against.  For example, this array might contain values @"3045", @"3046" and @"3047" when filtering on review ids 3045, 3046 and 3047.
 */
- (void)setFilterOnIncludedType:(BVIncludeType)type
                   forAttribute:(NSString *)attribute
                       equality:(BVEquality)equality
                         values:(NSArray *)values;

/*!
 Adds a generic parameter to the request.  This method should be used as a last resort when another method does not exist for a particular request you would like to make.  Behavior may be undefined.
@param name of parameter.
@param value of parameter.
 */
- (void)setGenericParameterWithName:(NSString *)name value:(NSString *)value;

/*!
 Sends request asynchronously.  A delegate must be set before this method is called.
 */
- (void)send;
/*!
 Convenience method to set delegate and send request asynchronously.
 @param delegate  The client delegate to receive BVDelegate notifications.
 */
- (void) sendRequestWithDelegate:(id<BVDelegate>)delegate;

@end
