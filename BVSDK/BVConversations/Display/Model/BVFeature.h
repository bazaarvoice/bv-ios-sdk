//
//  BVFeature.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVFeature : NSObject

@property(nullable) NSString *feature;
@property(nullable) NSString *localizedFeature;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
