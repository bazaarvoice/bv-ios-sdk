//
//  BVDisplayableProduct.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

@protocol BVDisplayableProductContent

@property (nonatomic, strong, readonly, nonnull) NSString *identifier;
@property (nonatomic, strong, readonly, nullable) NSString *displayName;
@property (nonatomic, strong, readonly, nullable) NSString *displayImageUrl;
@property (nonatomic, strong, readonly, nullable) NSNumber *averageRating;

@end
