//
//  BVNetworkDelegateTestsDelegate.m
//  BVSDKTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVNetworkDelegateTestsDelegate.h"
#import <XCTest/XCTest.h>

@interface BVNetworkDelegateTestsDelegate ()
@property(nonatomic, strong) dispatch_queue_t blockQueue;
@property(nonatomic, assign) BOOL urlSessionHappened;
@property(nonatomic, assign) BOOL urlSessionTaskHappened;
@end

@implementation BVNetworkDelegateTestsDelegate

@synthesize blockQueue = _blockQueue,
            urlSessionExpectation = _urlSessionExpectation,
            urlSessionTaskExpectation = _urlSessionTaskExpectation;

- (XCTestExpectation *)urlSessionExpectation {
  __block XCTestExpectation *tempExpectation = nil;
  dispatch_sync(self.blockQueue, ^{
    tempExpectation = self->_urlSessionExpectation;
  });
  return tempExpectation;
}

- (void)setUrlSessionExpectation:(XCTestExpectation *)urlSessionExpectation {
  dispatch_sync(self.blockQueue, ^{
    self->_urlSessionExpectation = urlSessionExpectation;
  });
}

- (XCTestExpectation *)urlSessionTaskExpectation {
  __block XCTestExpectation *tempExpectation = nil;
  dispatch_sync(self.blockQueue, ^{
    tempExpectation = self->_urlSessionTaskExpectation;
  });
  return tempExpectation;
}

- (void)setUrlSessionTaskExpectation:
    (XCTestExpectation *)urlSessionTaskExpectation {
  dispatch_sync(self.blockQueue, ^{
    self->_urlSessionTaskExpectation = urlSessionTaskExpectation;
  });
}

- (instancetype)init {
  if ((self = [super init])) {
    _blockQueue = dispatch_queue_create(
        "com.bazaarvoice.BVNetworkDelegateTestsDelegate.blockQueue",
        DISPATCH_QUEUE_SERIAL);
  }
  return self;
}

- (nonnull NSURLSession *)URLSessionForBVObject:
    (nullable id<NSObject>)bvObject {
  if (self.urlSessionExpectation && !self.urlSessionHappened) {
    self.urlSessionHappened = YES;
    [self.urlSessionExpectation fulfill];
  }
  return [NSURLSession sharedSession];
}

- (void)URLSessionTask:(nonnull NSURLSessionTask *)urlSessionTask
          fromBVObject:(nonnull id<NSObject>)bvObject
        withURLSession:(nonnull NSURLSession *)session {
  if (self.urlSessionTaskExpectation && !self.urlSessionTaskHappened) {
    self.urlSessionTaskHappened = YES;
    [self.urlSessionTaskExpectation fulfill];
  }
}

@end
