//
//  BVRecommendationsRequest+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVRECOMMENDATIONSREQUEST_PRIVATE_H
#define BVRECOMMENDATIONSREQUEST_PRIVATE_H

#import "BVRecommendationsRequest.h"

@interface BVRecommendationsRequest ()

@property(nonatomic, assign) BOOL allowInactiveProducts;
@property(nullable, nonatomic, strong) NSDate *lookback;
@property(nonatomic, readonly) BOOL purposeIsSet;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableSet<NSString *> *includes;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableSet<NSString *> *interests;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableSet<NSString *> *strategies;

- (nonnull instancetype)addStrategy:(nonnull NSString *)strategy;

@end

#endif /* BVRECOMMENDATIONSREQUEST_PRIVATE_H */
