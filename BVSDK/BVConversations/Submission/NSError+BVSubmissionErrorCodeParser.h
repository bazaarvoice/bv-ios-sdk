//
//  NSError+BVSubmissionErrorCodeParser.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorCode.h"
#import <Foundation/Foundation.h>

@interface NSError (BVSubmissionErrorCodeParser)
- (BVSubmissionErrorCode)bvSubmissionErrorCode;
@end
