//
//  BVMultiPart+NSURLRequest.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (MultiPart)

+ (nullable NSString *)
generateBoundaryWithData:(nonnull NSMutableData *)bodyData
    andFileName:(nonnull NSString *)fileName
    andContentDictionary:(nonnull NSDictionary *)contentDictionary;

@end
