//
//  BVURLSessionDelegate.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVURLSESSIONDELEGATE_H
#define BVURLSESSIONDELEGATE_H

#import <Foundation/Foundation.h>

@protocol BVURLSessionDelegate <NSObject>
@required

/*
 * This method will be invoked before an impending networking action to acquire
 * the NSURLSession to be used to create the cooresponding NSURLSessionTask. The
 * object that is responsible for the networking event will be passed as a
 * parameter to the callee so that the operation can be tracked through to the
 * NSURLSession delegate methods.
 */
- (nonnull NSURLSession *)URLSessionForBVObject:(nullable id)bvObject;

/*
 * This method will be invoked after a networking action is enqueued and returns
 * the NSURLSessionTask, object, and session responsible for a successfully
 * submitted (but not necessarily successfully completed) action.
 */
- (void)URLSessionTask:(nonnull NSURLSessionTask *)urlSessionTask
          fromBVObject:(nonnull id)bvObject
        withURLSession:(nonnull NSURLSession *)session;

@end

#endif /* BVURLSESSIONDELEGATE_H */
