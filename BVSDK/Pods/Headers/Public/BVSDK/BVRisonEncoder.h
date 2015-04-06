//
//  BVRisonEncoder.h
//  BazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 3/8/15.
//  Copyright (c) 2015 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 BVRisonEncoder contains simple RISON format encoding logic used to shorten URI lengths.
 */
@interface BVRisonEncoder : NSObject

/*!
 Encode the object to RISON format
 @param value The object to be encoded.
 */
+(NSString*)encode:(NSObject*)value;

/*!
 URL percent-encode a string with special considerations for RISON formatting.
 @param originalString The string to be URL percent-encoded
 */
+(NSString*)urlEncode:(NSString*)originalString;

@end
