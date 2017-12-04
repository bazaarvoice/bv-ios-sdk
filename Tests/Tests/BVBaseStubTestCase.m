//
//  BVBaseStubTestCase.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BVBaseStubTestCase.h"

@implementation BVBaseStubTestCase

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each
  // test method in the class.
  [super tearDown];
  [OHHTTPStubs removeAllStubs];
}

- (void)addStubWith200ResponseForJSONFileNamed:(NSString *)resultFile {

  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return [request.URL.host containsString:@"bazaarvoice.com"];
  }
      withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        // return normal user profile from /users API
        return [[OHHTTPStubsResponse
            responseWithFileAtPath:OHPathForFile(resultFile, self.class)
                        statusCode:200
                           headers:@{
                             @"Content-Type" :
                                 @"application/json;charset=utf-8"
                           }] responseTime:OHHTTPStubsDownloadSpeedWifi];
      }];
}

- (void)addStubWithResultFile:(NSString *)resultFile
                   statusCode:(int)httpStatus
                  withHeaders:(NSDictionary *)httpHeaders {

  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return [request.URL.host containsString:@"bazaarvoice.com"];
  }
      withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        // return normal user profile from /users API
        return [[OHHTTPStubsResponse
            responseWithFileAtPath:OHPathForFile(resultFile, self.class)
                        statusCode:httpStatus
                           headers:httpHeaders]
            responseTime:OHHTTPStubsDownloadSpeedWifi];
      }];
}

@end
