//
//  BVReviewHighlightsBaseRequest.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BVReviewHighlightsBaseRequest : NSObject

- (nonnull NSString *)url;

- (void)
loadContent:(nonnull BVReviewHighlightsBaseRequest *)request
 completion:(nonnull void (^)(NSDictionary *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure;

@end

NS_ASSUME_NONNULL_END
