//
//  BVProduct.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProduct.h"
#import "BVBrand.h"
#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"
#import "BVQAStatistics.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import "BVReviewStatistics.h"

@interface BVProduct ()

@property(nonnull, readwrite) NSArray<BVReview *> *includedReviews;
@property(nonnull, readwrite) NSArray<BVQuestion *> *includedQuestions;

@end

@implementation BVProduct

@synthesize identifier = _identifier;
@synthesize displayImageUrl;
@synthesize displayName;
@synthesize averageRating;

- (id)initWithApiResponse:(NSDictionary *)apiResponse
                 includes:(BVConversationsInclude *)includes {
  if ((self = [super init])) {

    if (!includes) {
      includes =
          [[BVConversationsInclude alloc] initWithApiResponse:apiResponse];
    }

    self.brand = [[BVBrand alloc] initWithApiResponse:apiResponse[@"Brand"]];

    SET_IF_NOT_NULL(self.productDescription, apiResponse[@"Description"])
    SET_IF_NOT_NULL(self.brandExternalId, apiResponse[@"BrandExternalId"])
    SET_IF_NOT_NULL(self.productPageUrl, apiResponse[@"ProductPageUrl"])
    SET_IF_NOT_NULL(self.name, apiResponse[@"Name"])
    SET_IF_NOT_NULL(self.categoryId, apiResponse[@"CategoryId"])
    SET_IF_NOT_NULL(_identifier, apiResponse[@"Id"])
    SET_IF_NOT_NULL(self.imageUrl, apiResponse[@"ImageUrl"])
    SET_IF_NOT_NULL(self.attributes, apiResponse[@"Attributes"])
    SET_IF_NOT_NULL(self.manufacturerPartNumbers,
                    apiResponse[@"ManufacturerPartNumbers"])
    SET_IF_NOT_NULL(self.familyIds, apiResponse[@"FamilyIds"])
    SET_IF_NOT_NULL(self.ISBNs, apiResponse[@"ISBNs"])
    SET_IF_NOT_NULL(self.UPCs, apiResponse[@"UPCs"])
    SET_IF_NOT_NULL(self.EANs, apiResponse[@"EANs"])
    SET_IF_NOT_NULL(self.modelNumbers, apiResponse[@"ModelNumbers"])

    self.filteredReviewStatistics = [[BVReviewStatistics alloc]
        initWithApiResponse:apiResponse[@"FilteredReviewStatistics"]];

    self.reviewStatistics = [[BVReviewStatistics alloc]
          initWithApiResponse:apiResponse[@"ReviewStatistics"]];

    self.qaStatistics = [[BVQAStatistics alloc]
        initWithApiResponse:apiResponse[@"FilteredQAStatistics"]];

    if (!self.qaStatistics) {
      self.qaStatistics = [[BVQAStatistics alloc]
          initWithApiResponse:apiResponse[@"QAStatistics"]];
    }

    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedQuestions, includes,
                                             Question);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedReviews, includes,
                                             Review);
  }
  return self;
}

- (NSString *)displayName {
  return _name;
}

- (NSString *)displayImageUrl {
  return _imageUrl;
}

- (NSNumber *)averageRating {
  return _reviewStatistics.averageOverallRating;
}

@end
