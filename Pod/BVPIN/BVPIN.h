//
//  BVPIN.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVDisplayableProductContent.h"
#import <Foundation/Foundation.h>

@interface BVPIN : NSObject <BVDisplayableProductContent>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
    NS_DESIGNATED_INITIALIZER;

@property(nonatomic, strong, readonly) NSNumber *averageRating;

@property(nonatomic, strong, readonly) NSString *imageUrl;

@property(nonatomic, strong, readonly) NSString *productPageURL;

@property(nonatomic, strong, readonly) NSString *name;

@end
