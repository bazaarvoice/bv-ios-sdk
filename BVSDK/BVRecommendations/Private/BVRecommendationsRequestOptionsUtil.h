//
//  BVRecommendationsRequestOptionsUtil.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVRecommendationsRequestOptions.h"
#import <Foundation/Foundation.h>

@interface BVRecommendationsRequestOptionsUtil : NSObject

+ (nonnull NSString *)valueForRecommendationsRequestInclude:
    (BVRecommendationsRequestInclude)recommendationsRequestInclude;

+ (nonnull NSString *)valueForRecommendationsRequestPurpose:
    (BVRecommendationsRequestPurpose)recommendationsRequestPurpose;

@end
