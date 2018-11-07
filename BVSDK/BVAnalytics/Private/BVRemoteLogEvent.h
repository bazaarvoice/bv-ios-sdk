//
//  BVRemoteLogEvent.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVAnalyticEvent.h"

@interface BVRemoteLogEvent : NSObject <BVAnalyticEvent>

- (nonnull instancetype)initWithError:(nonnull NSString *)error
                     localeIdentifier:(nonnull NSString *)localeIdentifier
                                  log:(nonnull NSString *)log
                            bvProduct:(nonnull NSString *)bvProduct;

- (nonnull instancetype)__unavailable init;

@property(nonnull, nonatomic, strong, readonly) NSString *error;
@property(nonnull, nonatomic, strong, readonly) NSString *localeIdentifier;
@property(nonnull, nonatomic, strong, readonly) NSString *log;
@property(nonnull, nonatomic, strong, readonly) NSString *bvProduct;

@end
