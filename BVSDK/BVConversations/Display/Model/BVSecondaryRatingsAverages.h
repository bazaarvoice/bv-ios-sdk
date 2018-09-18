//
//  SecondaryRatingsAverages.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVSecondaryRatingsAverages : NSDictionary

+ (nullable BVSecondaryRatingsAverages *)createWithDictionary:
    (nullable id)apiResponse;

@end
