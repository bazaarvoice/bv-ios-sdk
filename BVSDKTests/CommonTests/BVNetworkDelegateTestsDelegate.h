//
//  BVNetworkDelegateTestsDelegate.h
//  BVSDKTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVURLSessionDelegate.h"
#import <Foundation/Foundation.h>

@class XCTestExpectation;
@interface BVNetworkDelegateTestsDelegate : NSObject <BVURLSessionDelegate>

@property(nonatomic, weak, nullable) XCTestExpectation *urlSessionExpectation;
@property(nonatomic, weak, nullable)
    XCTestExpectation *urlSessionTaskExpectation;

@end
