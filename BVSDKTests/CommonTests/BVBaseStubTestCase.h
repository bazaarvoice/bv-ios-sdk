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

@property(nonatomic, assign) NSTimeInterval barrierTimeout;

// Will stub out calls to bazaarvoice.com, return 200, and a resultFile with
// Content-Type = application/json
- (void)addStubWith200ResponseForJSONFileNamed:(nonnull NSString *)resultFile;
- (void)addStubWith200ResponseForJSONFilesNamed:
    (nonnull NSArray<NSString *> *)resultFileArray;

// Use this method to stub calls to bazaarvoice and add any resultFile, headers,
// and HTTP status you want
- (void)addStubWithResultFile:(nonnull NSString *)resultFile
                   statusCode:(NSInteger)httpStatus
                  withHeaders:(nonnull NSDictionary *)httpHeaders;

// Use these methods to protect against XCode going on to run other tests until
// this test suite has completed all tests. The problem is that even if you are
// waiting on expectations that doesn't mean that Xcode won't start running
// other tests. So, for example, if you're kicking off tests which wait for
// notifications to be delivered and it's possible that other tests will spawn
// notifications that you're waiting for, well, then you can be hosed. So the
// way this works is that whenever you're entering a context you make a
// 'retainBarrier' call and whenever you leave you make a 'releaseBarrier' call.
// Of course, make sure they're balanced else you're error out.
- (BOOL)isBarrierHeld;
- (void)retainBarrier;
- (void)releaseBarrier;
- (void)forceWaitForBarrierWithTimeout:(NSTimeInterval)barrierTimeout;

@end

#endif /* BVBaseStubTestCase_h */
