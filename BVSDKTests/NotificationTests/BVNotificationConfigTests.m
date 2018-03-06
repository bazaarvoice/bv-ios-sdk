//
//  BVNotificationConfigTests.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVNotificationConfigTests.h"
#import <BVSDK/BVProductReviewNotificationConfigurationLoader.h>
#import <BVSDK/BVSDKManager.h>
#import <BVSDK/BVStoreNotificationConfigurationLoader.h>

#import "BVStoreNotificationConfigurationLoader+Private.h"

static const NSString *clientId = @"testingtesting";
@implementation BVNotificationConfigTests : BVBaseStubTestCase

- (void)setUp {
  [super setUp];

  NSDictionary *configDict = @{
    @"apiKeyConversationsStores" : @"fakeymcfakersonfakekey",
    @"clientId" : clientId
  };
  [BVSDKManager configureWithConfiguration:configDict
                                configType:BVConfigurationTypeStaging];
  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelError];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of
  // each test method in the class.
  [super tearDown];
}

- (void)addStubForS3ResponseForConfigPath:(NSString *)path
                            JSONFileNamed:(NSString *)resultFile {
  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return [request.URL.absoluteString isEqualToString:path];
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

- (void)testLoadStoreNotificationConfigAPI {
  __weak XCTestExpectation *expectation =
      [self expectationWithDescription:@"testLoadNotificationConfigAPI"];

  [self addStubForS3ResponseForConfigPath:
            [NSString
                stringWithFormat:@"%@/incubator-mobile-apps/sdk/%@/ios/%@/"
                                 @"conversations-stores/geofenceConfig.json",
                                 @"https://s3.amazonaws.com", @"v1", clientId]
                            JSONFileNamed:@"testNotificationConfig.json"];

  // Testing private API
  [[BVStoreNotificationConfigurationLoader sharedManager]
      loadStoreNotificationConfiguration:^(
          BVStoreReviewNotificationProperties *__nonnull response) {
        // success
        BVStoreReviewNotificationProperties *noteProps =
            [[BVStoreNotificationConfigurationLoader sharedManager]
                bvStoreReviewNotificationProperties];

        XCTAssertNotNil(noteProps, @"Config note properties should not be nil");
        XCTAssertEqual(noteProps.visitDuration, 5, @"Unexpected visitDuration");
        XCTAssertEqual(noteProps.notificationDelay, 5,
                       @"Unexpected notificationDelay");
        XCTAssertEqual(noteProps.remindMeLaterDuration, 86400,
                       @"Unexpected remindMeLaterDuration");

        XCTAssertTrue([noteProps.customUrlScheme isEqualToString:@"bvsdkdemo"],
                      @"customUrlScheme failure");

        XCTAssertTrue(
            [noteProps.reviewPromtDispayText
                isEqualToString:@"Thank you for visiting Endurance Cycles."],
            @"fail reviewPromtDispayText");
        XCTAssertTrue(
            [noteProps.reviewPromptSubtitleText
                isEqualToString:@"How would you describe your experience?"],
            @"fail reviewPromptSubtitleText");
        XCTAssertTrue([noteProps.reviewPromtNoReview
                          isEqualToString:@"I did not visit this store"],
                      @"fail reviewPromtNoReview");
        XCTAssertTrue([noteProps.reviewPromptYesReview
                          isEqualToString:@"Positive Experience"],
                      @"fail reviewPromptYesReview");
        XCTAssertTrue([noteProps.reviewPromptRemindText
                          isEqualToString:@"Bad Experience"],
                      @"fail reviewPromptRemindText");

        XCTAssertTrue(noteProps.requestReviewOnAppOpen,
                      @"fail requestReviewOnAppOpen flag");
        XCTAssertTrue(noteProps.notificationsEnabled,
                      @"fail notificationsEnabled flag");

        [expectation fulfill];

      }
      failure:^(NSError *__nonnull errors) {
        // fail
        XCTFail("testLoadNotificationConfigAPI should not have called failure "
                "block");
      }];

  [self waitForExpectations];
}

/*
- (void)testLoadNotificationFailure {

    __weak XCTestExpectation *expectation = [self
expectationWithDescription:@"testLoadNotificationFailure"];

    // Testing private API
    [[BVSDKManager sharedManager] loadNotificationConfiguration];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 *
NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Check and see if we have all the notification configuration options

        BVStoreReviewNotificationProperties *noteProps = [BVSDKManager
sharedManager].bvStoreReviewNotificationProperties;

        XCTAssertNil(noteProps, @"Config note properties should be nil");

        [expectation fulfill];

    });


    [self waitForExpectations];


}
*/
- (void)waitForExpectations {
  [self waitForExpectationsWithTimeout:30.0
                               handler:^(NSError *error) {

                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }

                               }];
}

@end
