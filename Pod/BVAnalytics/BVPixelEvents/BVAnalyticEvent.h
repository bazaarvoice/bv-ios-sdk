//
//  BVAnalyticEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVAnalyticEvent_h
#define BVAnalyticEvent_h

@protocol BVAnalyticEvent <NSObject>

@required

/// Other transaction parameters such as user email.
@property(nullable, nonatomic, strong) NSDictionary *additionalParams;

/**
 Converts the analytic event implementing the BVAnalyticEvent protocol to a
 dictionary.

 @return The NSDictionary representation of this Bazaarvoice mobile analytic
 event.
 */
- (nonnull NSDictionary *)toRaw;

@end

#endif /* BVAnalyticEvent_h */
