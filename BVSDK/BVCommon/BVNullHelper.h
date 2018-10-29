//
//  BVNullHelper.h
//  Bazaarvoice SDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __IS_A(X, CLASS) ([(X) isMemberOfClass:[CLASS class]])
#define __IS_KIND_OF(X, CLASS) ([(X) isKindOfClass:[CLASS class]])

#define __ASSERT_IS_A(X, CLASS, MSG)                                           \
  do {                                                                         \
    NSAssert(__IS_A(X, CLASS), MSG);                                           \
  } while (0)

#define __ASSERT_ISNT_A(X, CLASS, MSG)                                         \
  do {                                                                         \
    NSAssert(!__IS_A(X, CLASS), MSG);                                          \
  } while (0)

#ifndef BVNullHelper_h
#define BVNullHelper_h

#define SET_IF_NOT_NULL(target, value)                                         \
  if (value && value != [NSNull null]) {                                       \
    target = value;                                                            \
  }

#define SET_DEFAULT_IF_NULL(target, value, default)                            \
  if (value && value && value != [NSNull null]) {                              \
    target = value;                                                            \
  } else {                                                                     \
    target = default;                                                          \
  }

static inline BOOL isObjectNilOrNull(NSObject *object) {
  if (!object || object == [NSNull null]) {
    return YES;
  } else {
    return NO;
  }
}

#endif /* BVNullHelper_h */
