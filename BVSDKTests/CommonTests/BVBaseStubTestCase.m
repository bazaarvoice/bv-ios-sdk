//
//  BVBaseStubTestCase.m
//  BVSDKTests
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#define WaitForAllGroupsToBeEmpty(timeout)                                     \
  do {                                                                         \
    if (![self waitForGroupToBeEmptyWithTimeout:timeout]) {                    \
      XCTFail(@"Timed out waiting for groups to empty.");                      \
    }                                                                          \
  } while (NO)

#import "BVBaseStubTestCase.h"
#import <BVSDK/BVNullHelper.h>
#import <XCTest/XCTest.h>

@interface BVBaseStubTestCase ()
// This is to synchronize on tests which have side-effects with other tests
// being ran. It's basically a barrier between XCTestCases so that Xcode won't
// enqueue new tests until these tests complete.
@property(nonatomic) dispatch_group_t barrier;
@property(nonatomic, readonly) dispatch_queue_t barrierQueue;
@end

@implementation BVBaseStubTestCase

@synthesize barrier = _barrier, barrierQueue = _barrierQueue;

- (dispatch_queue_t)barrierQueue {
  if (NULL == _barrierQueue) {
    _barrierQueue = dispatch_queue_create(
        "com.bazaarvoice.BVSDKTest.barrierQueue", DISPATCH_QUEUE_SERIAL);
  }
  return _barrierQueue;
}

- (dispatch_group_t)barrier {
  __block dispatch_group_t tempBarrier = NULL;
  dispatch_sync(self.barrierQueue, ^{
    tempBarrier = self->_barrier;
  });
  return tempBarrier;
}

- (void)setBarrier:(dispatch_group_t)barrier {
  dispatch_sync(self.barrierQueue, ^{
    self->_barrier = barrier;
  });
}

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of
  // each
  // test method in the class.
  [super tearDown];
  [OHHTTPStubs removeAllStubs];
}

- (void)stubWithJSON:(NSString *)resultFile {
  [self stubWithJSON:resultFile withPassingTest:nil];
}

- (void)forceStubWithJSON:(nonnull NSString *)resultFile {
  [self forceStubWithJSON:resultFile withPassingTest:nil];
}

- (void)stubWithJSON:(nonnull NSString *)resultFile
     withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock {
  [self stubWithJSONSequence:@[ resultFile ] withPassingTest:testBlock];
}

- (void)forceStubWithJSON:(nonnull NSString *)resultFile
          withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock {
  [self forceStubWithJSONSequence:@[ resultFile ] withPassingTest:testBlock];
}

- (void)stubWithJSONSequence:(nonnull NSArray<NSString *> *)resultFileArray {
  [self stubWithJSONSequence:resultFileArray withPassingTest:nil];
}

- (void)forceStubWithJSONSequence:
    (nonnull NSArray<NSString *> *)resultFileArray {
  [self forceStubWithJSONSequence:resultFileArray withPassingTest:nil];
}

- (void)stubWithJSONSequence:(nonnull NSArray<NSString *> *)resultFileArray
             withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock {
#ifdef BV_IGNORE_TESTING_STUBS
  [self forceStubWithJSONSequence:resultFileArray withPassingTest:testBlock];
#else
  return;
#endif
}

- (void)forceStubWithJSONSequence:(nonnull NSArray<NSString *> *)resultFileArray
                  withPassingTest:(nullable OHHTTPStubsTestBlock)testBlock {
  __block NSUInteger callCount = 0;
  NSUInteger fileCount = resultFileArray.count;

  OHHTTPStubsTestBlock passableTest =
      testBlock ?: ^BOOL(NSURLRequest *request) {
        return [request.URL.host containsString:@"bazaarvoice.com"];
      };

  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return passableTest(request);
  }
      withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {

        if (callCount < fileCount) {
          id fileObj = [resultFileArray objectAtIndex:callCount];
          if (__IS_KIND_OF(fileObj, NSString)) {
            NSString *resultFile = (NSString *)fileObj;

            // Increment count
            callCount++;

            return [[OHHTTPStubsResponse
                responseWithFileAtPath:OHPathForFile(resultFile, self.class)
                            statusCode:200
                               headers:@{
                                 @"Content-Type" :
                                     @"application/json;charset=utf-8"
                               }] responseTime:OHHTTPStubsDownloadSpeedWifi];
          }
        }

        NSError *resourceUnavailableError =
            [NSError errorWithDomain:NSURLErrorDomain
                                code:kCFURLErrorResourceUnavailable
                            userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:resourceUnavailableError];
      }];
}

- (void)stubWithResultFile:(NSString *)resultFile
                statusCode:(NSInteger)httpStatus
               withHeaders:(NSDictionary *)httpHeaders {
#ifdef BV_IGNORE_TESTING_STUBS
  [self forceStubWithResultFile:resultFile
                     statusCode:httpStatus
                    withHeaders:httpHeaders];
#else
  return;
#endif
}

- (void)forceStubWithResultFile:(nonnull NSString *)resultFile
                     statusCode:(NSInteger)httpStatus
                    withHeaders:(nonnull NSDictionary *)httpHeaders {
  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return [request.URL.host containsString:@"bazaarvoice.com"];
  }
      withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        // return normal user profile from /users API
        return [[OHHTTPStubsResponse
            responseWithFileAtPath:OHPathForFile(resultFile, self.class)
                        statusCode:(int)httpStatus
                           headers:httpHeaders]
            responseTime:OHHTTPStubsDownloadSpeedWifi];
      }];
}

#pragma mark - Synchronization Primitives

/*
 * Thanks to the people at obj.io: https://www.objc.io/issues/15-testing/xctest/
 */
- (BOOL)isBarrierHeld {
  return (NULL != self.barrier);
}

- (void)retainBarrier {
  if (NULL == self.barrier) {
    self.barrier = dispatch_group_create();
  }
  dispatch_group_enter(self.barrier);
}

- (void)releaseBarrier {
  if (NULL != self.barrier) {
    dispatch_group_leave(self.barrier);
  }
}

- (void)forceWaitForBarrierWithTimeout:(NSTimeInterval)barrierTimeout {
  (void)[self waitForGroupToBeEmptyWithTimeout:barrierTimeout];
}

- (BOOL)waitForGroupToBeEmptyWithTimeout:(NSTimeInterval)timeout {
  if (NULL == self.barrier) {
    return YES;
  }

  NSDate *const end = [[NSDate date] dateByAddingTimeInterval:timeout];
  int64_t delta = (int64_t)timeout;
  dispatch_time_t dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, delta);

  __block BOOL didComplete = NO;
  dispatch_group_notify(self.barrier, dispatch_get_main_queue(), ^{
    didComplete = YES;
  });

  dispatch_group_wait(self.barrier, dispatchTimeout);

  return didComplete && (0. < [end timeIntervalSinceNow]);
}

@end
