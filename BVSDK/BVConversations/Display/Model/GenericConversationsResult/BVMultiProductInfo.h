//
//  BVMultiProductInfo.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BVMultiProductInfo : NSObject

@property(nullable) NSString *identifier;
@property(nullable) NSString *name;
@property(nullable) NSString *productDescription;
@property(nullable) NSString *imageUrl;
@property(nullable) NSString *productPageUrl;
@property(nullable) NSNumber *totalReviewCount;
@property(nullable) NSNumber *averageOverallRating;
@property(nullable) NSNumber *rating;
@property(nullable) NSString *reviewTitle;
@property(nullable) NSString *reviewText;
@property BOOL isMissing;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end

NS_ASSUME_NONNULL_END
