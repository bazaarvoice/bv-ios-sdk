//
//  BVLogger+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVLOGGER_PRIVATE_H
#define BVLOGGER_PRIVATE_H

#import "BVLogger.h"

#define BVAssert(expression, ...)                                              \
  do {                                                                         \
    if (!(expression)) {                                                       \
      NSString *__BVAssert_temp_string = [NSString                             \
          stringWithFormat:@"Assertion failure: %s in %s on line %s:%d. %@",   \
                           #expression, __func__, __FILE__, __LINE__,          \
                           [NSString stringWithFormat:@"" __VA_ARGS__]];       \
      [[BVLogger sharedLogger] error:__BVAssert_temp_string];                  \
      abort();                                                                 \
    }                                                                          \
  } while (0)

#endif /* BVLOGGER_PRIVATE_H */
