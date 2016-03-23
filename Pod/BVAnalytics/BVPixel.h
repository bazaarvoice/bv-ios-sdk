//
//  BVPixel.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVTransaction.h"
#import "BVConversion.h"


/// Static class used to queue Conversion events
@interface BVPixel : NSObject


/// @param transaction Queues Conversion Transaction event for ROI reporting on customer purchases.
+(void)trackConversionTransaction:(BVTransaction* _Nonnull)transaction;


/// @param conversion Queues Conversion non-transaction event for ROI reporting on a custom metric.
+(void)trackNonCommerceConversion:(BVConversion* _Nonnull)conversion;

@end
