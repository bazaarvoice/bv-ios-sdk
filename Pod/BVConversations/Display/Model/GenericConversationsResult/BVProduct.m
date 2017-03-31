//
//  BVProduct.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProduct.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"

@implementation BVProduct

@synthesize identifier = _identifier;
@synthesize displayImageUrl;
@synthesize displayName;
@synthesize averageRating;

-(id)initWithApiResponse:(NSDictionary *)apiResponse includes:(BVConversationsInclude *)includes {
    
    self = [super init];
    if(self) {
        _includes = includes;
        _apiResponse = apiResponse;
        self.brand = [[BVBrand alloc] initWithApiResponse:apiResponse[@"Brand"]];
            
        SET_IF_NOT_NULL(self.productDescription, apiResponse[@"Description"])
        SET_IF_NOT_NULL(self.brandExternalId, apiResponse[@"BrandExternalId"])
        SET_IF_NOT_NULL(self.productPageUrl, apiResponse[@"ProductPageUrl"])
        SET_IF_NOT_NULL(self.name, apiResponse[@"Name"])
        SET_IF_NOT_NULL(self.categoryId, apiResponse[@"CategoryId"])
        SET_IF_NOT_NULL(_identifier, apiResponse[@"Id"])
        SET_IF_NOT_NULL(self.imageUrl, apiResponse[@"ImageUrl"])
        SET_IF_NOT_NULL(self.attributes, apiResponse[@"Attributes"])
        SET_IF_NOT_NULL(self.manufacturerPartNumbers, apiResponse[@"ManufacturerPartNumbers"])
        SET_IF_NOT_NULL(self.familyIds, apiResponse[@"FamilyIds"])
        SET_IF_NOT_NULL(self.ISBNs, apiResponse[@"ISBNs"])
        SET_IF_NOT_NULL(self.UPCs, apiResponse[@"UPCs"])
        SET_IF_NOT_NULL(self.EANs, apiResponse[@"EANs"])
        SET_IF_NOT_NULL(self.modelNumbers, apiResponse[@"ModelNumbers"])

        self.reviewStatistics = [[BVReviewStatistics alloc] initWithApiResponse:apiResponse[@"FilteredReviewStatistics"]];
        
        if (!self.reviewStatistics ) {
            self.reviewStatistics = [[BVReviewStatistics alloc] initWithApiResponse:apiResponse[@"ReviewStatistics"]];
        }
        
        self.qaStatistics = [[BVQAStatistics alloc] initWithApiResponse:apiResponse[@"FilteredQAStatistics"]];
        
        if (!self.qaStatistics){
            self.qaStatistics = [[BVQAStatistics alloc] initWithApiResponse:apiResponse[@"QAStatistics"]];
        }

        NSArray<NSString*>* reviewIds = apiResponse[@"ReviewIds"];
        NSMutableArray<BVReview*>* tempReviews = [NSMutableArray array];
        for(NSString* reviewId in reviewIds) {
            BVReview* review = [includes getReviewById:reviewId];
            [tempReviews addObject:review];
        }
        self.includedReviews = tempReviews;
        
        NSArray<NSString*>* questionIds = apiResponse[@"QuestionIds"];
        NSMutableArray<BVQuestion*>* tempQuestions = [NSMutableArray array];
        for(NSString* questionId in questionIds) {
            BVQuestion* question = [includes getQuestionById:questionId];
            [tempQuestions addObject:question];
        
        }
        self.includedQuestions = tempQuestions;

    }
    return self;
    
}

-(NSString*)displayName {
    return _name;
}

-(NSString*)displayImageUrl {
    return _imageUrl;
}

-(NSNumber*)averageRating {
    return _reviewStatistics.averageOverallRating;
}

@end
