//
//  BVRandom+NSString.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BVRandom)
+ (nonnull NSString *)randomHexStringWithLength:(NSUInteger)length;
@end
