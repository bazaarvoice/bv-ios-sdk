//
//  NSError+BVErrorCodeParser.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVErrorCode.h"

@interface NSError (BVErrorCodeParser)
-(BVErrorCode)bvErrorCode;
@end

