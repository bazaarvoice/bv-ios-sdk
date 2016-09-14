//
//  BVBaseStubTestCase.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVBaseStubTestCase_h
#define BVBaseStubTestCase_h

#import <XCTest/XCTest.h>

// 3rd Party
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>


@interface BVBaseStubTestCase : XCTestCase

// Will stub out calls to bazaarvoice.com, return 200, and a resultFile with Content-Type = application/json
- (void)addStubWith200ResponseForJSONFileNamed:(NSString *)resultFile;

// Use this method to stub calls to bazaarvoice and add any resultFile, headers, and HTTP status you want
- (void)addStubWithResultFile:(NSString *)resultFile statusCode:(int)httpStatus withHeaders:(NSDictionary * )httpHeaders;

@end


#endif /* BVBaseStubTestCase_h */
