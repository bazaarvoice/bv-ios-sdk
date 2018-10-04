//
//  BVBaseStubTestCase.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVBaseStubTestCase_h
#define BVBaseStubTestCase_h

#import <XCTest/XCTest.h>

/// 3rd Party
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

@interface BVBaseStubTestCase : XCTestCase

@property(nonatomic, assign) NSTimeInterval barrierTimeout;

/// Will stub out calls to bazaarvoice.com, return 200, and a resultFile with
/// Content-Type = application/json
/// - Note:
/// \
/// The force variants *always* will stub, whereas, the other may conditionally
/// stub based on the environment settings. If you don't know which one to use,
/// always use the *non* force variant(s).
- (void)stubWithJSON:(nonnull NSString *)resultFile;
- (void)forceStubWithJSON:(nonnull NSString *)resultFile;

- (void)stubWithJSON:(nonnull NSString *)resultFile
     withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock;
- (void)forceStubWithJSON:(nonnull NSString *)resultFile
          withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock;

- (void)stubWithJSONSequence:(nonnull NSArray<NSString *> *)resultFileArray;
- (void)forceStubWithJSONSequence:
    (nonnull NSArray<NSString *> *)resultFileArray;

- (void)stubWithJSONSequence:(nonnull NSArray<NSString *> *)resultFileArray
             withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock;
- (void)forceStubWithJSONSequence:(nonnull NSArray<NSString *> *)resultFileArray
                  withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock;

/// Use this method to stub calls to bazaarvoice and add any resultFile,
/// headers, and HTTP status you want
- (void)stubWithResultFile:(nonnull NSString *)resultFile
                statusCode:(NSInteger)httpStatus
               withHeaders:(nonnull NSDictionary *)httpHeaders;
- (void)forceStubWithResultFile:(nonnull NSString *)resultFile
                     statusCode:(NSInteger)httpStatus
                    withHeaders:(nonnull NSDictionary *)httpHeaders;

/// Use these methods to protect against Xcode going on to run other tests until
/// this test suite has completed all tests. The problem is that even if you are
/// waiting on expectations that doesn't mean that Xcode won't start running
/// other tests. So, for example, if you're kicking off tests which wait for
/// notifications to be delivered and it's possible that other tests will spawn
/// notifications that you're waiting for, well, then you can be hosed. So the
/// way this works is that whenever you're entering a context you make a
/// 'retainBarrier' call and whenever you leave you make a 'releaseBarrier'
/// call. Of course, make sure they're balanced else you're error out.
- (BOOL)isBarrierHeld;
- (void)retainBarrier;
- (void)releaseBarrier;
- (void)forceWaitForBarrierWithTimeout:(NSTimeInterval)barrierTimeout;

@end

#endif /* BVBaseStubTestCase_h */
