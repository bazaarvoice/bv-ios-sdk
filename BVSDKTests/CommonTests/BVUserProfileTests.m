//
//  BVAdsSDKTestsTests.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <BVSDK/BVAnalyticsManager+Testing.h>
#import <BVSDK/BVAuthenticatedUser+Testing.h>
#import <BVSDK/BVCommon.h>
#import <XCTest/XCTest.h>

#import "BVBaseStubTestCase.h"

static BVAuthenticatedUser *user = nil;

@interface BVUserProfileTests : BVBaseStubTestCase
@property(nonatomic, copy) OHHTTPStubsTestBlock passableTest;
@property(nonatomic, strong) XCTestExpectation *userProfileExpectation;
@end

@implementation BVUserProfileTests

- (void)setUp {
  [super setUp];

  user = nil;

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(userProfileUpdated:)
             name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED
           object:nil];

  // set up the BVAdsSDK with your clientId, and AdsPassKey
  BVSDKManager *sdkManager = [BVSDKManager sharedManager];
  NSDictionary *configDict =
      @{@"apiKeyShopperAdvertising" : @"fakekey", @"clientId" : @"iosunittest"};
  [BVSDKManager configureWithConfiguration:configDict
                                configType:BVConfigurationTypeStaging];
  [sdkManager setLogLevel:BVLogLevelError];

  self.passableTest = ^BOOL(NSURLRequest *_Nonnull request) {
    return ![request.HTTPMethod isEqualToString:@"POST"] &&
           [request.URL.host containsString:@"bazaarvoice.com"];
  };
}

- (void)tearDown {
  [super tearDown];

  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED
              object:nil];

  self.userProfileExpectation = nil;
}

- (void)waitForExpectations {
  [self waitForExpectationsWithTimeout:30.0
                               handler:^(NSError *error) {

                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@",
                                           error);
                                 }

                               }];
}

- (dispatch_block_t)generateAnalyticsCompletionBlock {
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"HH:mm:ss"];
  NSString *dateString = [dateFormat stringFromDate:now];

  NSString *description =
      [NSString stringWithFormat:@"BVUserProfileTests-%@", dateString];
  XCTestExpectation *expectation =
      [self expectationWithDescription:description];

  return ^{
    [expectation fulfill];
  };
}

// For a typical user profile call, the client will simply pass in the UAS
// string and be done with it. The logic behind the call to
// BVSDKManager#setUserWithAuthString will handle all requirements for making
// sure the profile is updated.
// The text itself
- (void)testSetUserProfile {

  self.userProfileExpectation =
      [self expectationWithDescription:@"Expecting user profile network event"];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testSetUserProfile"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  [self addStubWith200ResponseForJSONFileNamed:@"userProfile1.json"
                               withPassingTest:self.passableTest];

  [[BVSDKManager sharedManager]
      setUserWithAuthString:@"0ce436b29697d6bc74f30f724b9b0bb6646174653d3132333"
                            @"4267573657269643d5265636f6d6d656e646174696f6e7353"
                            @"646b54657374"]; // pre-populated with a small
                                              // profile interested in "pets",
                                              // "powersports", "gamefish", and
                                              // others -- for testing purposes.

  [self waitForExpectations];
}

// This is the notification callback (for internal testing) that sends the
// BVAuthenticatedUser object with profile info
- (void)userProfileUpdated:(NSNotification *)notification {

  XCTAssertNotNil(notification,
                  @"NSNotification was nil from user profile fetch");

  user = (BVAuthenticatedUser *)[notification object];
  XCTAssertNotNil(user, @"User profile is nil after profile fetch");
  NSDictionary *keywords = [user getTargetingKeywords];

  NSString *brandsKeyWords = [keywords objectForKey:@"brands"];
  NSString *interestsKeyWords = [keywords objectForKey:@"interests"];

  XCTAssertTrue([brandsKeyWords containsString:@"brand1_MED"],
                @"Expected brand1_MED in keyword result");
  XCTAssertTrue([brandsKeyWords containsString:@"anotherbrand_MED"],
                @"Expected anotherbrand_MED in keyword result");

  XCTAssertTrue([interestsKeyWords containsString:@"womensshoes_LOW"],
                @"Expected womensshoes_LOW in keyword result");
  XCTAssertTrue([interestsKeyWords containsString:@"uncategorized_MED"],
                @"Expected uncategorized_MED in keyword result");
  XCTAssertTrue([interestsKeyWords containsString:@"apparelaccessories_HIGH"],
                @"Expected apparelaccessories_HIGH in keyword result");

  [self.userProfileExpectation fulfill];
}

@end
