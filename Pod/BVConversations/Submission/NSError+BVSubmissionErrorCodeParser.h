//
//  NSError+BVSubmissionErrorCodeParser.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmissionErrorCode.h"
#import "BVFieldError.h"

@interface NSError (BVSubmissionErrorCodeParser)
-(BVSubmissionErrorCode)bvSubmissionErrorCode;
@end
