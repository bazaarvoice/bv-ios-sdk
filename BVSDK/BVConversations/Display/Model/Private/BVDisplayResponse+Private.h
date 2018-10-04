//
//  BVDisplayResponse+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVDISPLAYRESPONSE_PRIVATE_H
#define BVDISPLAYRESPONSE_PRIVATE_H

#import "BVDisplayResponse.h"

@class BVConversationsInclude;
@class BVGenericConversationsResult;

@interface BVDisplayResponse <
    __covariant GenericType : BVGenericConversationsResult *>
() - (nonnull GenericType)createResult : (nonnull NSDictionary *)raw includes
    : (nullable BVConversationsInclude *)includes;
@end

#endif /* BVDISPLAYRESPONSE_PRIVATE_H */
