//
//  BVBaseProductRequest+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVBASEPRODUCTREQUEST_PRIVATE_H
#define BVBASEPRODUCTREQUEST_PRIVATE_H

#import "BVBaseProductRequest.h"
#import "BVInclude.h"

@interface BVBaseProductRequest ()

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<BVInclude *> *)statistics;
- (nonnull NSString *)includesToParams:(nonnull NSArray<BVInclude *> *)includes;

@end

#endif /* BVBASEPRODUCTREQUEST_PRIVATE_H */
