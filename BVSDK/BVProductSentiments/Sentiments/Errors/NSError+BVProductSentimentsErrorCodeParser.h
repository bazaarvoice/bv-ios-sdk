//
//  NSError+BVProductSentimentsErrorCodeParser.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef NSError_BVProductSentimentsErrorCodeParser_h
#define NSError_BVProductSentimentsErrorCodeParser_h

#import "BVProductSentimentsErrorCode.h"
#import <Foundation/Foundation.h>

@interface NSError (BVProductSentimentsErrorCodeParser)
- (BVProductSentimentsErrorCode)bvProductSentimentsErrorCode;
@end

#endif /* NSError_BVProductSentimentsErrorCodeParser_h */
