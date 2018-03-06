//
//  BVNetworkingManager.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#define __EXISTS(OBJ, SELECTOR) ([(OBJ) respondsToSelector:@selector(SELECTOR)])

#import "BVNetworkingManager.h"

@interface BVNetworkingManager () <NSURLSessionDelegate,
                                   NSURLSessionTaskDelegate>
@property(nonatomic, strong, readwrite) NSURLSession *bvNetworkingSession;
@property(nonatomic, strong) NSOperationQueue *networkingOperationQueue;
@end

@implementation BVNetworkingManager

__strong static BVNetworkingManager *networkingManagerInstance = nil;
+ (nonnull instancetype)sharedManager {
  static dispatch_once_t networkingManagerOnceToken;
  dispatch_once(&networkingManagerOnceToken, ^{
    networkingManagerInstance = [[self alloc] init];
  });
  return networkingManagerInstance;
}

@synthesize bvNetworkingSession = _bvNetworkingSession,
            networkingOperationQueue = _networkingOperationQueue;

- (nonnull NSURLSession *)bvNetworkingSession {
  static dispatch_once_t networkingSessionOnceToken;
  dispatch_once(&networkingSessionOnceToken, ^{
    NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    if (@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *)) {
      if (__EXISTS(config, waitsForConnectivity)) {
        config.waitsForConnectivity = YES;
      }
    }

    _bvNetworkingSession =
        [NSURLSession sessionWithConfiguration:config
                                      delegate:self
                                 delegateQueue:_networkingOperationQueue];
  });

  return _bvNetworkingSession;
}

- (instancetype)init {
  if ((self = [super init])) {
    _networkingOperationQueue = [[NSOperationQueue alloc] init];
    _networkingOperationQueue.maxConcurrentOperationCount = 1;
    if (@available(iOS 8.0, macOS 10.10, tvOS 9.0, watchOS 2.0, *)) {
      if (__EXISTS(_networkingOperationQueue, qualityOfService)) {
        _networkingOperationQueue.qualityOfService =
            NSQualityOfServiceUserInitiated;
      }
    }
  }
  return self;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
    didBecomeInvalidWithError:(nullable NSError *)error {
  /// Unused for now.
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
    taskIsWaitingForConnectivity:(NSURLSessionTask *)task {
  /// Unused for now.
}

- (void)URLSession:(NSURLSession *)session
                        task:(NSURLSessionTask *)task
             didSendBodyData:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
  /// Unused for now.
}

- (void)URLSession:(NSURLSession *)session
                          task:(NSURLSessionTask *)task
    didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
    API_AVAILABLE(ios(10.0)) {
  /// Unused for now.
}

- (void)URLSession:(NSURLSession *)session
                    task:(NSURLSessionTask *)task
    didCompleteWithError:(nullable NSError *)error {
  /// Unused for now.
}

@end
