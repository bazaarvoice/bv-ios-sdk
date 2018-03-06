//
//  BVCommentsResponse.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BVBaseConversationsResponse.h"
#import "BVComment.h"

@interface BVCommentsResponse : BVBaseConversationsResultsResponse <BVComment *>

@end
