//
//  BVRecommendationsRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationsRequest.h"

@interface BVRecommendationsRequest()

@property (readwrite) NSString* _Nullable productId;
@property (readwrite) NSString* _Nullable categoryId;
@property (readwrite) NSUInteger limit;

@end

@implementation BVRecommendationsRequest

- (instancetype)initWithLimit:(NSUInteger)limit {
    self = [super init];
    if(self){
        self.productId = nil;
        self.categoryId = nil;
        self.limit = limit;
    }
    return self;
}

- (instancetype)initWithLimit:(NSUInteger)limit withProductId:(NSString*)productId {
    self = [super init];
    if(self){
        self.productId = productId;
        self.categoryId = nil;
        self.limit = limit;
    }
    return self;
}

- (instancetype)initWithLimit:(NSUInteger)limit withCategoryId:(NSString*)categoryId {
    self = [super init];
    if(self){
        self.productId = nil;
        self.categoryId = categoryId;
        self.limit = limit;
    }
    return self;
}

@end
