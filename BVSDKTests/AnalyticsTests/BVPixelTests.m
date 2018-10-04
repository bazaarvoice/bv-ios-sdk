//
//  BVBaseStubTestCase.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <BVSDK/BVAnalyticsManager+Testing.h>
#import <BVSDK/BVLocaleServiceManager.h>
#import <BVSDK/BVSDKConfiguration.h>
#import <BVSDK/BVSDKManager+Private.h>
#import <BVSDK/BVSDKManager.h>

#import "BVBaseStubTestCase.h"

@interface BVAnalyticsManager (TestAccessors)
@property(strong) NSMutableArray *eventQueue;
@end

@interface NSDictionary (DictionaryTest)

- (BOOL)containsDictionary:(NSDictionary *)otherDictionary;

@end

@implementation NSDictionary (DictionaryTest)

- (BOOL)containsDictionary:(NSDictionary *)otherDictionary {

  BOOL contains = YES;

  for (NSString *otherKey in otherDictionary) {
    NSObject *otherValue = [otherDictionary objectForKey:otherKey];

    // test
    NSObject *testValue = [self objectForKey:otherKey];
    if (![testValue isEqual:otherValue]) {
      contains = NO;
      break;
    }
  }

  return contains;
}

@end

@interface BVPixelTests : BVBaseStubTestCase
@end

@implementation BVPixelTests

- (void)setUp {
  [super setUp];

  [[BVAnalyticsManager sharedManager] setFlushInterval:0.1];

  NSDictionary *configDict = @{@"clientId" : @"mobileBVPixelTestsiOS"};
  [BVSDKManager configureWithConfiguration:configDict
                                configType:BVConfigurationTypeProd];
  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelAnalyticsOnly];
}

- (void)tearDown {

  [super tearDown];
}

- (void)waitForAnalytics {
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
      [NSString stringWithFormat:@"BVPixelTests-%@", dateString];
  XCTestExpectation *expectation =
      [self expectationWithDescription:description];

  return ^{
    [expectation fulfill];
  };
}

- (void)checkCommonEventParams:(NSDictionary *)eventDict {

  NSString *source = [eventDict objectForKey:@"source"];
  NSString *idfa = [eventDict objectForKey:@"advertisingId"];
  NSString *mobileSource = [eventDict objectForKey:@"mobileSource"];
  NSString *UA = [eventDict objectForKey:@"UA"];
  NSString *clientId = [eventDict objectForKey:@"client"];
  NSString *hashedIP = [eventDict objectForKey:@"HashedIP"];

  XCTAssertTrue([source isEqualToString:@"native-mobile-sdk"]);
  XCTAssertTrue([mobileSource isEqualToString:@"bv-ios-sdk"]);
  XCTAssertTrue([clientId
      isEqualToString:[BVSDKManager sharedManager].configuration.clientId]);
  XCTAssertTrue([hashedIP isEqualToString:@"default"]);

  XCTAssertNotNil(idfa);
  XCTAssertNotNil(UA);
}

- (void)testProductPageViewEventParameters {

  [[BVAnalyticsManager sharedManager]
      enqueuePageViewTestWithName:@"testProductPageViewEventParameters"
              withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *testValues = @{
    @"productId" : @"12345",
    @"categoryId" : @"testCategoryId",
    @"rootCategoryId" : @"electronics"
  };

  BVPageViewEvent *pvEvent = [[BVPageViewEvent alloc]
           initWithProductId:[testValues objectForKey:@"productId"]
      withBVPixelProductType:BVPixelProductTypeConversationsReviews
                   withBrand:nil
              withCategoryId:[testValues objectForKey:@"categoryId"]
          withRootCategoryId:[testValues objectForKey:@"rootCategoryId"]
        withAdditionalParams:nil];

  NSDictionary *eventDict = [pvEvent toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:PRODUCT_PAGEVIEW_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test parameter values are in the dictionary
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains, "Are the input params in the event?");

  [self checkCommonEventParams:eventDict];

  // Fire the PageView event
  [BVPixel trackEvent:pvEvent];

  [self waitForAnalytics];
}

- (void)testImpressionEventParametersReview {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testImpressionEventParametersReview"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *testValues = @{
    @"productId" : @"12345",
    @"contentId" : @"9876",
    @"categoryId" : @"catId",
    @"contentType" : @"Review",
    @"bvProduct" : @"RatingsAndReviews"
  };

  BVImpressionEvent *reviewImpression = [[BVImpressionEvent alloc]
         initWithProductId:[testValues objectForKey:@"productId"]
             withContentId:[testValues objectForKey:@"contentId"]
            withCategoryId:[testValues objectForKey:@"categoryId"]
           withProductType:BVPixelProductTypeConversationsReviews
           withContentType:BVPixelImpressionContentTypeReview
                 withBrand:nil
      withAdditionalParams:nil];

  NSDictionary *eventDict = [reviewImpression toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:UGC_IMPRESSION_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test parameter values are in the dictionary
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains, "Are the input params in the event?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:reviewImpression];

  [self waitForAnalytics];
}

- (void)testImpressionEventParametersQuestion {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testImpressionEventParametersQuestion"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *testValues = @{
    @"productId" : @"12345",
    @"contentId" : @"9876",
    @"categoryId" : @"catId",
    @"contentType" : @"Question",
    @"bvProduct" : @"RatingsAndReviews"
  };

  BVImpressionEvent *questionImpression = [[BVImpressionEvent alloc]
         initWithProductId:[testValues objectForKey:@"productId"]
             withContentId:[testValues objectForKey:@"contentId"]
            withCategoryId:[testValues objectForKey:@"categoryId"]
           withProductType:BVPixelProductTypeConversationsReviews
           withContentType:BVPixelImpressionContentTypeQuestion
                 withBrand:nil
      withAdditionalParams:nil];

  NSDictionary *eventDict = [questionImpression toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:UGC_IMPRESSION_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test parameter values are in the dictionary
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains, "Are the input params in the event?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:questionImpression];

  [self waitForAnalytics];
}

- (void)testImpressionEventParametersAnswer {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testImpressionEventParametersAnswer"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *testValues = @{
    @"productId" : @"12345",
    @"contentId" : @"9876",
    @"categoryId" : @"catId",
    @"contentType" : @"Answer",
    @"bvProduct" : @"RatingsAndReviews"
  };

  BVImpressionEvent *answerImpression = [[BVImpressionEvent alloc]
         initWithProductId:[testValues objectForKey:@"productId"]
             withContentId:[testValues objectForKey:@"contentId"]
            withCategoryId:[testValues objectForKey:@"categoryId"]
           withProductType:BVPixelProductTypeConversationsReviews
           withContentType:BVPixelImpressionContentTypeAnswer
                 withBrand:nil
      withAdditionalParams:nil];

  NSDictionary *eventDict = [answerImpression toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:UGC_IMPRESSION_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test parameter values are in the dictionary
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains, "Are the input params in the event?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:answerImpression];

  [self waitForAnalytics];
}

- (void)testViewedCGC {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testViewedCGC"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *testValues = @{
    @"productId" : @"12345",
    @"categoryId" : @"catId",
    @"bvProduct" : @"RatingsAndReviews"
  };

  BVViewedCGCEvent *viewedCGCEvent = [[BVViewedCGCEvent alloc]
         initWithProductId:[testValues objectForKey:@"productId"]
        withRootCategoryID:nil
            withCategoryId:[testValues objectForKey:@"categoryId"]
           withProductType:BVPixelProductTypeConversationsReviews
                 withBrand:nil
      withAdditionalParams:nil];

  NSDictionary *eventDict = [viewedCGCEvent toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:VIEWED_CGC_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test parameter values are in the dictionary
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains, "Are the input params in the event?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:viewedCGCEvent];

  [self waitForAnalytics];
}

- (void)testFeatureUsedProfile {

  [[BVAnalyticsManager sharedManager] setFlushInterval:0.1];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testFeatureUsedProfile"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *extraParams =
      @{@"interaction" : @"false", @"page" : @"authorId"};

  NSDictionary *testValues = @{
    @"productId" : @"none",
    @"name" : @"Profile",
    @"bvProduct" : @"Profiles"
  };

  BVFeatureUsedEvent *profileEvent = [[BVFeatureUsedEvent alloc]
         initWithProductId:@"none"
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsProfile
             withEventName:BVPixelFeatureUsedNameProfile
      withAdditionalParams:extraParams];

  NSDictionary *eventDict = [profileEvent toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:USED_FEATURE_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test parameter values are in the dictionary
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains, "Are the input params in the event?");

  // Test extra params
  contains = [eventDict containsDictionary:extraParams];
  XCTAssertTrue(contains,
                "Were the extra params for the profile added correctly?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:profileEvent];

  [self waitForAnalytics];
}

- (void)testUsedFeatureWriteReview {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testUsedFeatureWriteReview"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *testValues = @{
    @"productId" : @"12345",
    @"bvProduct" : @"RatingsAndReviews",
    @"name" : @"Write",
    @"detail1" : @"Review"
  };

  NSDictionary *extraParams = @{@"detail1" : @"Review"};

  BVFeatureUsedEvent *writeReviewEvent = [[BVFeatureUsedEvent alloc]
         initWithProductId:[testValues objectForKey:@"productId"]
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNameWriteReview
      withAdditionalParams:extraParams];

  NSDictionary *eventDict = [writeReviewEvent toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:USED_FEATURE_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test parameter values are in the dictionary
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains, "Are the input params in the event?");

  // Test extra params
  contains = [eventDict containsDictionary:extraParams];
  XCTAssertTrue(contains,
                "Were the extra params for the profile added correctly?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:writeReviewEvent];

  [self waitForAnalytics];
}

- (void)testUsedFeatureFeedbackHelpfulness {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testUsedFeatureFeedbackHelpfulness"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *additionalParams = @{
    @"contentType" : [BVPixelImpressionContentTypeUtil
        toString:BVPixelImpressionContentTypeReview],
    @"contentId" : @"abcdef",
    @"detail1" : @"Positive"
  };

  BVFeatureUsedEvent *feedbackEvent = [[BVFeatureUsedEvent alloc]
         initWithProductId:@"12345"
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNameFeedback
      withAdditionalParams:additionalParams];

  NSDictionary *eventDict = [feedbackEvent toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:USED_FEATURE_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test extra params
  contains = [eventDict containsDictionary:additionalParams];
  XCTAssertTrue(contains,
                "Were the extra params for the profile added correctly?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:feedbackEvent];

  [self waitForAnalytics];
}

- (void)testUsedFeatureFeedbackInappropriate {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testUsedFeatureFeedbackInappropriate"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *additionalParams = @{
    @"contentType" : [BVPixelImpressionContentTypeUtil
        toString:BVPixelImpressionContentTypeQuestion],
    @"contentId" : @"abcdef",
    @"detail1" : @"Inappropriate"
  };

  BVFeatureUsedEvent *feedbackEvent = [[BVFeatureUsedEvent alloc]
         initWithProductId:@"12345"
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsQuestionAnswer
             withEventName:BVPixelFeatureUsedEventNameInappropriate
      withAdditionalParams:additionalParams];

  NSDictionary *eventDict = [feedbackEvent toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:USED_FEATURE_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test extra params
  contains = [eventDict containsDictionary:additionalParams];
  XCTAssertTrue(contains,
                "Were the extra params for the profile added correctly?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:feedbackEvent];

  [self waitForAnalytics];
}

- (void)testInViewEvent {

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testInViewEvent"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSDictionary *testValues = @{
    @"productId" : @"12345",
    @"bvProduct" : @"RatingsAndReviews",
    @"name" : @"InView",
    @"component" : @"ReviewsTableView"
  };

  BVInViewEvent *inViewEvent = [[BVInViewEvent alloc]
         initWithProductId:[testValues objectForKey:@"productId"]
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
           withContainerId:[testValues objectForKey:@"component"]
      withAdditionalParams:nil];

  NSDictionary *eventDict = [inViewEvent toRaw];

  // Test the required schema is defined correctly
  BOOL contains = [eventDict containsDictionary:FEATURE_USED_INVIEW_SCHEMA];
  XCTAssertTrue(contains, "Does the default schema exist for this product?");

  // Test the required schema is defined correctly
  contains = [eventDict containsDictionary:testValues];
  XCTAssertTrue(contains,
                "Are all the test values added to the event properly?");

  [self checkCommonEventParams:eventDict];

  [BVPixel trackEvent:inViewEvent];

  [self waitForAnalytics];
}

- (void)testTransactionConversionNoPII {

  [self forceStubWithJSON:@"emptyJSON.json"];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testTransactionConversionNoPII"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSArray *orderItems =
      @[ [[BVTransactionItem alloc] initWithSku:@"123"
                                           name:@"test product"
                                       category:@"home and garden"
                                          price:99.99
                                       quantity:1
                                       imageUrl:nil] ];
  BVTransactionEvent *transaction = [[BVTransactionEvent alloc]
      initWithOrderId:@"testorderid"
           orderTotal:99.99
           orderItems:orderItems
       andOtherParams:@{@"state" : @"TX", @"city" : @"Austin"}];

  [self checkCommonEventParams:[transaction toRaw]];
  [self checkCommonEventParams:[transaction toRawNonPII]];

  [BVPixel trackEvent:transaction];

  XCTAssert([[BVAnalyticsManager sharedManager] eventQueue].count == 1,
            @"Conversions without PII should only produce one event");

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testTransactionConversionPII {

  [self forceStubWithJSON:@"emptyJSON.json"];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testTransactionConversionPII"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  NSArray *orderItems =
      @[ [[BVTransactionItem alloc] initWithSku:@"123"
                                           name:@"test product"
                                       category:@"home and garden"
                                          price:99.99
                                       quantity:1
                                       imageUrl:nil] ];
  BVTransactionEvent *transaction =
      [[BVTransactionEvent alloc] initWithOrderId:@"testorderid"
                                       orderTotal:99.99
                                       orderItems:orderItems
                                   andOtherParams:@{
                                     @"state" : @"TX",
                                     @"city" : @"Austin",
                                     /*PII*/ @"email" : @"some.one@domain.com"
                                   }];

  NSDictionary *transactionPIIDict = [transaction toRaw];
  NSDictionary *transactionNoPII = [transaction toRawNonPII];

  [self checkCommonEventParams:transactionPIIDict]; // PII is in event, but IDFA
                                                    // is removed
  [self checkCommonEventParams:transactionNoPII]; // PII is not in the event and
                                                  // IDFA is present

  // Default event that has PII (e.g. email) will have set idfa to nontracking
  XCTAssertTrue([[transactionPIIDict objectForKey:@"advertisingId"]
      isEqualToString:@"nontracking"]);
  XCTAssertTrue(
      [[transactionPIIDict objectForKey:@"hadPII"] isEqualToString:@"true"]);
  XCTAssertTrue([[transactionPIIDict objectForKey:@"email"]
      isEqualToString:@"some.one@domain.com"]);

  // For the nonPII-created dict, the email would be stripped but idfa presetn
  XCTAssertNil([transactionNoPII objectForKey:@"email"]);
  XCTAssertTrue(
      [[transactionNoPII objectForKey:@"hadPII"] isEqualToString:@"true"]);
  XCTAssertFalse([[transactionNoPII objectForKey:@"advertisingId"]
      isEqualToString:@"nontracking"]);

  [BVPixel trackEvent:transaction];

  XCTAssert([[BVAnalyticsManager sharedManager] eventQueue].count == 2,
            @"Conversions with PII should produce two events");

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testNonTransactionConversionNoPII {

  [self forceStubWithJSON:@"emptyJSON.json"];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testNonTransactionConversionNoPII"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  BVConversionEvent *conversion = [[BVConversionEvent alloc]
      initWithType:@"Broucher Download"
             value:@"HotSpringsSpas"
             label:@"TestLabel"
       otherParams:@{@"state" : @"TX", @"city" : @"Austin"}];

  [self checkCommonEventParams:[conversion toRaw]];
  [self checkCommonEventParams:[conversion toRawNonPII]];

  [BVPixel trackEvent:conversion];

  XCTAssert([[BVAnalyticsManager sharedManager] eventQueue].count == 1,
            @"Non-transactional Conversions without PII should only produce "
            @"one event");

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

- (void)testNonTransactionConversionPII {

  [self forceStubWithJSON:@"emptyJSON.json"];

  [[BVAnalyticsManager sharedManager]
      enqueueImpressionTestWithName:@"testNonTransactionConversionPII"
                withCompletionBlock:[self generateAnalyticsCompletionBlock]];

  BVConversionEvent *conversion =
      [[BVConversionEvent alloc] initWithType:@"Broucher Download"
                                        value:@"HotSpringsSpas"
                                        label:@"TestLabel"
                                  otherParams:@{
                                    @"state" : @"TX",
                                    @"city" : @"Austin",
                                    /*PII*/ @"email" : @"some.one@domain.com"
                                  }];

  NSDictionary *conversionPIIDict = [conversion toRaw];
  NSDictionary *conversionNoPII = [conversion toRawNonPII];

  [self checkCommonEventParams:conversionPIIDict]; // PII is in event, but IDFA
                                                   // is removed
  [self checkCommonEventParams:conversionNoPII]; // PII is not in the event and
                                                 // IDFA is present

  // Default event that has PII (e.g. email) will have set idfa to nontracking
  XCTAssertTrue([[conversionPIIDict objectForKey:@"advertisingId"]
      isEqualToString:@"nontracking"]);
  XCTAssertTrue(
      [[conversionPIIDict objectForKey:@"hadPII"] isEqualToString:@"true"]);
  XCTAssertTrue([[conversionPIIDict objectForKey:@"email"]
      isEqualToString:@"some.one@domain.com"]);

  // For the nonPII-created dict, the email would be stripped but idfa presetn
  XCTAssertNil([conversionNoPII objectForKey:@"email"]);
  XCTAssertTrue(
      [[conversionNoPII objectForKey:@"hadPII"] isEqualToString:@"true"]);
  XCTAssertFalse([[conversionNoPII objectForKey:@"advertisingId"]
      isEqualToString:@"nontracking"]);

  [BVPixel trackEvent:conversion];

  XCTAssert(
      [[BVAnalyticsManager sharedManager] eventQueue].count == 2,
      @"Non-transactional Conversions with PII should produce two events");

  [[BVAnalyticsManager sharedManager] flushQueue];

  [self waitForAnalytics];
}

@end
