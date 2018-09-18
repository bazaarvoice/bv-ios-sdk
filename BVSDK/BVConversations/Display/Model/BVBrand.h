//
//  Brand.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The brand associated with a product.
 */
@interface BVBrand : NSObject

@property(nullable) NSString *name;
@property(nullable) NSString *identifier;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
