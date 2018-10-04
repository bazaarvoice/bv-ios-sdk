//
//  BVProduct.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDisplayableProductContent.h"
#import "BVGenericConversationsResult.h"

@class BVBrand;
@class BVQAStatistics;
@class BVQuestion;
@class BVReview;
@class BVReviewStatistics;

/*
 The main information contained within a `BVProductResponse` which is a response
 to `BVProductDisplayPageRequest`.
 Some commonly used data in a product:
    Product page URL is included in the `productPageUrl` property.
    Product image URL is included in the `imageUrl` property.
    Review statistics is included in the `reviewStatistics` property, if
 requested in the `BVReviewsRequest` object.
    Questions&Answers statistics is included in the `qaStatistics` property, if
 requested in the `BVReviewsRequest` object.
    Reviews attached to this product are included in the `includedReviews`
 property, if requested in the `BVReviewsRequest` object.
    Questions attached to this product are included in the `includedQuestion`
 property, if requested in the `BVReviewsRequest` object.
 */
@interface BVProduct
    : BVGenericConversationsResult <BVDisplayableProductContent>

@property(nullable) BVBrand *brand;
@property(nonnull) NSArray<NSString *> *ISBNs;
@property(nonnull) NSArray<NSString *> *UPCs;
@property(nullable) NSString *productDescription;
@property(nonnull) NSArray<NSString *> *manufacturerPartNumbers;
@property(nullable) NSDictionary *attributes;
@property(nullable) NSString *brandExternalId;
@property(nullable) NSString *productPageUrl;
@property(nonnull) NSArray<NSString *> *familyIds;
@property(nullable) NSString *imageUrl;
@property(nonnull) NSArray<NSString *> *EANs;
@property(nullable) NSString *name;
@property(nullable) NSString *categoryId;
@property(nonnull) NSArray<NSString *> *modelNumbers;
@property(nullable) BVReviewStatistics *reviewStatistics;
@property(nullable) BVQAStatistics *qaStatistics;

@property(nonnull, readonly) NSArray<BVReview *> *includedReviews;
@property(nonnull, readonly) NSArray<BVQuestion *> *includedQuestions;

@end
