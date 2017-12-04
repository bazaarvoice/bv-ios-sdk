//
//  NSError+BVErrorCodeParser.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVErrorCode.h"
#import <Foundation/Foundation.h>

@interface NSError (BVErrorCodeParser)
- (BVErrorCode)bvErrorCode;
@end
