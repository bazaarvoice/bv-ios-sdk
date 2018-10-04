//
//  BVGenericConversationsResult+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVGENERICCONVERSATIONSRRESULT_PRIVATE_H
#define BVGENERICCONVERSATIONSRRESULT_PRIVATE_H

#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult.h"

@interface BVGenericConversationsResult ()

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse
                         includes:(nullable BVConversationsInclude *)includes;

@end

#endif /* BVGENERICCONVERSATIONSRRESULT_PRIVATE_H */
