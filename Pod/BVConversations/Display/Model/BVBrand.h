//
//  Brand.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The brand associated with a product.
 */
@interface BVBrand : NSObject

@property NSString* _Nullable name;
@property NSString* _Nullable identifier;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
