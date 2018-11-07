//
//  BVUserAgent+NSURLRequest.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (UserAgent)

+ (nonnull NSString *)bvUserAgentWithLocaleIdentifier:
    (nullable NSString *)localeIdentifier;

@end
