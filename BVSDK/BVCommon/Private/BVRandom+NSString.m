//
//  BVRandom+NSString.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVRandom+NSString.h"
#import <Security/SecRandom.h>

@implementation NSString (BVRandom)

+ (nonnull NSString *)randomHexStringWithLength:(NSUInteger)length {
  // Stack based scratchpad
  uint8_t randomBytes[length];
  size_t randomBytesLength = sizeof(randomBytes) / sizeof(randomBytes[0]);
  // Copy random bytes
  if (errSecSuccess !=
      SecRandomCopyBytes(kSecRandomDefault, randomBytesLength, randomBytes)) {
    // If this fails, we just fall back to a less-than-stellar
    // cryptographically random set of bytes. Who cares though since we just
    // need garbage as we're not seeding for cryptographically secure keys.
    arc4random_buf(randomBytes, randomBytesLength);
  }

  // Build up random boundary string with prefix
  NSMutableString *randomString = [NSMutableString string];
  for (NSInteger index = 0; index < randomBytesLength; index++) {
    [randomString appendFormat:@"%x", randomBytes[index]];
  }

  return randomString;
}

@end
