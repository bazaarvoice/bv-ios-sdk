//
//  Product.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVGenericConversationsResult.h"
#import "BVBrand.h"
#import "BVReviewStatistics.h"
#import "BVQAStatistics.h"
#import "BVReview.h"
#import "BVQuestion.h"

/*
 The main information contained within a `BVProductResponse` which is a response to `BVProductDisplayPageRequest`.
 Some commonly used data in a product:
    Product page URL is included in the `productPageUrl` property.
    Product image URL is included in the `imageUrl` property.
    Review statistics is included in the `reviewStatistics` property, if requested in the `BVReviewsRequest` object.
    Questions&Answers statistics is included in the `qaStatistics` property, if requested in the `BVReviewsRequest` object.
    Reviews attached to this product are included in the `includedReviews` property, if requested in the `BVReviewsRequest` object.
    Questions attached to this product are included in the `includedQuestion` property, if requested in the `BVReviewsRequest` object.
 */
@interface BVProduct : NSObject<BVGenericConversationsResult>

@property BVBrand* _Nullable brand;
@property NSArray<NSString*>* _Nonnull ISBNs;
@property NSArray<NSString*>* _Nonnull UPCs;
@property NSString* _Nullable productDescription;
@property NSArray<NSString*>* _Nonnull manufacturerPartNumbers;
@property NSDictionary* _Nullable attributes;
@property NSString* _Nullable brandExternalId;
@property NSString* _Nullable productPageUrl;
@property NSArray<NSString*>* _Nonnull familyIds;
@property NSString* _Nullable imageUrl;
@property NSArray<NSString*>* _Nonnull EANs;
@property NSString* _Nullable name;
@property NSString* _Nullable categoryId;
@property NSString* _Nullable identifier;
@property NSArray<NSString*>* _Nonnull modelNumbers;
@property BVReviewStatistics* _Nullable reviewStatistics;
@property BVQAStatistics* _Nullable qaStatistics;

@property NSArray<BVReview*>* _Nonnull includedReviews;
@property NSArray<BVQuestion*>* _Nonnull includedQuestions;

@end
