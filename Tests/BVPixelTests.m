//
//  BVBaseStubTestCase.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BVBaseStubTestCase.h"
#import "BVSDKManager.h"
#import "BVAnalyticsManager.h"
#import "BVSDKConfiguration.h"

#define ANALYTICS_TEST_USING_MOCK_DATA 1 // Setting to 1 uses mock result. Set to 0 to make network request.

@interface BVAnalyticsManager (TestAccessors)
    @property (strong) NSMutableArray* eventQueue;
@end

@interface NSDictionary (DictionaryTest)

-(BOOL)containsDictionary:(NSDictionary *)otherDictionary;

@end

@implementation NSDictionary (DictionaryTest)

-(BOOL)containsDictionary:(NSDictionary *)otherDictionary{
    
    BOOL contains = YES;
    
    for (NSString *otherKey in otherDictionary){
        NSObject *otherValue = [otherDictionary objectForKey:otherKey];
        
        // test
        NSObject *testValue = [self objectForKey:otherKey];
        if (![testValue isEqual:otherValue]){
            contains = NO;
            break;
            
        }
    }
    
    return contains;
}

@end



@interface BVPixelTests : BVBaseStubTestCase
{
    XCTestExpectation *impressionExpectation;
    XCTestExpectation *pageviewExpectation;
    int numberOfExpectedImpressionAnalyticsEvents;
    int numberOfExpectedPageviewAnalyticsEvents;
}
@end

@implementation BVPixelTests

- (void)setUp {
    [super setUp];
    
    NSDictionary *configDict = @{@"clientId": @"mobileBVPixelTestsiOS"};
    [BVSDKManager configureWithConfiguration:configDict configType:BVConfigurationTypeProd];
    [[BVSDKManager sharedManager] setLogLevel:BVLogLevelAnalyticsOnly];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analyticsPageviewEventCompleted:)
                                                 name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analyticsImpressionEventCompleted:)
                                                 name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
                                               object:nil];
    
    impressionExpectation = [self expectationWithDescription:@"Expecting impression analytics events"];
    pageviewExpectation = [self expectationWithDescription:@"Expecting pageview analytics events"];
    numberOfExpectedImpressionAnalyticsEvents = 0;
    numberOfExpectedPageviewAnalyticsEvents = 0;
}

-(void)tearDown {
    
    [super tearDown];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED"
                                                  object:nil];
    
}

-(void)waitForAnalytics {
    [self waitForExpectationsWithTimeout:30.0 handler:^(NSError *error) {
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

-(void)analyticsImpressionEventCompleted:(NSNotification *)notification {
    
    NSLog(@"analytics impression event fired in tests: %i", numberOfExpectedImpressionAnalyticsEvents);
    
    NSError *err = (NSError *)[notification object];
    if (err){
        XCTFail(@"ERROR: Analytic event failed %@", err);
    } else {
        NSLog(@"Analytic Impression HTTP success.");
    }
    
    numberOfExpectedImpressionAnalyticsEvents -= 1;
    [self checkComplete];
    
}

-(void)analyticsPageviewEventCompleted:(NSNotification *)notification {
    
    NSLog(@"analytics pageview event fired in tests: %i", numberOfExpectedPageviewAnalyticsEvents);
    
    NSError *err = (NSError *)[notification object];
    if (err){
        XCTFail(@"ERROR: Analytic event failed %@", err);
    } else {
        NSLog(@"Analytic Page View HTTP success.");
    }
    
    numberOfExpectedPageviewAnalyticsEvents -= 1;
    [self checkComplete];
    
}

-(void)checkComplete {
    if(numberOfExpectedImpressionAnalyticsEvents == 0){
        [impressionExpectation fulfill];
        numberOfExpectedImpressionAnalyticsEvents = -1;
    }
    if(numberOfExpectedPageviewAnalyticsEvents == 0){
        [pageviewExpectation fulfill];
        numberOfExpectedPageviewAnalyticsEvents = -1;
    }
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
    XCTAssertTrue([clientId isEqualToString:[BVSDKManager sharedManager].configuration.clientId]);
    XCTAssertTrue([hashedIP isEqualToString:@"default"]);
    
    XCTAssertNotNil(idfa);
    XCTAssertNotNil(UA);
}



- (void)testProductPageViewEventParameters {
    
    numberOfExpectedImpressionAnalyticsEvents = 0;
    numberOfExpectedPageviewAnalyticsEvents = 1;
    
    NSDictionary *testValues = @{@"productId":@"12345",
                                 @"categoryId":@"testCategoryId",
                                 @"rootCategoryId":@"electronics"};
    
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
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *testValues = @{
                                 @"productId":@"12345",
                                 @"contentId":@"9876",
                                 @"categoryId":@"catId",
                                 @"contentType":@"Review",
                                 @"bvProduct":@"RatingsAndReviews"
                                 };
    
    BVImpressionEvent *reviewImpression = [[BVImpressionEvent alloc] initWithProductId:[testValues objectForKey:@"productId"]
                                                     withContentId:[testValues objectForKey:@"contentId"]
                                                    withCategoryId:[testValues objectForKey:@"categoryId"]
                                            withProductType:BVPixelProductTypeConversationsReviews
                                                   withContentType:BVPixelImpressionContentTypeReview
                                                         withBrand:nil withAdditionalParams:nil];
    
    
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
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *testValues = @{
                                 @"productId":@"12345",
                                 @"contentId":@"9876",
                                 @"categoryId":@"catId",
                                 @"contentType":@"Question",
                                 @"bvProduct":@"RatingsAndReviews"
                                 };
    
    BVImpressionEvent *questionImpression = [[BVImpressionEvent alloc] initWithProductId:[testValues objectForKey:@"productId"]
                                                                         withContentId:[testValues objectForKey:@"contentId"]
                                                                        withCategoryId:[testValues objectForKey:@"categoryId"]
                                                                withProductType:BVPixelProductTypeConversationsReviews
                                                                       withContentType:BVPixelImpressionContentTypeQuestion
                                                                             withBrand:nil withAdditionalParams:nil];
    
    
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
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *testValues = @{
                                 @"productId":@"12345",
                                 @"contentId":@"9876",
                                 @"categoryId":@"catId",
                                 @"contentType":@"Answer",
                                 @"bvProduct":@"RatingsAndReviews"
                                 };
    
    BVImpressionEvent *answerImpression = [[BVImpressionEvent alloc] initWithProductId:[testValues objectForKey:@"productId"]
                                                                           withContentId:[testValues objectForKey:@"contentId"]
                                                                          withCategoryId:[testValues objectForKey:@"categoryId"]
                                                                  withProductType:BVPixelProductTypeConversationsReviews
                                                                         withContentType:BVPixelImpressionContentTypeAnswer
                                                                               withBrand:nil withAdditionalParams:nil];
    
    
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

    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
        NSDictionary *testValues = @{
                                     @"productId":@"12345",
                                     @"categoryId":@"catId",
                                     @"bvProduct":@"RatingsAndReviews"
                                     };
    
    
    BVViewedCGCEvent *viewedCGCEvent = [[BVViewedCGCEvent alloc] initWithProductId:[testValues objectForKey:@"productId"]
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
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *extraParams = @{@"interaction":@"false",
                                  @"page":@"authorId"};
    
    NSDictionary *testValues = @{
                                 @"productId":@"none",
                                 @"name":@"Profile",
                                 @"bvProduct":@"Profiles"
                                 };
    
    BVFeatureUsedEvent *profileEvent = [[BVFeatureUsedEvent alloc] initWithProductId:@"none"
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
    XCTAssertTrue(contains, "Were the extra params for the profile added correctly?");
    
    [self checkCommonEventParams:eventDict];
    
    [BVPixel trackEvent:profileEvent];
    
    [self waitForAnalytics];
}

-(void)testUsedFeatureWriteReview {
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *testValues = @{@"productId":@"12345",
                                 @"bvProduct":@"RatingsAndReviews",
                                 @"name":@"Write",
                                 @"detail1":@"Review"
                                 };
    
    NSDictionary *extraParams = @{@"detail1":@"Review"};
    
    BVFeatureUsedEvent *writeReviewEvent = [[BVFeatureUsedEvent alloc] initWithProductId:[testValues objectForKey:@"productId"]
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
    XCTAssertTrue(contains, "Were the extra params for the profile added correctly?");
    
    [self checkCommonEventParams:eventDict];
    
    [BVPixel trackEvent:writeReviewEvent];
    
    [self waitForAnalytics];
    
}


-(void)testUsedFeatureFeedbackHelpfulness {
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *additionalParams = @{@"contentType":[BVPixelImpressionContentTypeUtil toString:BVPixelImpressionContentTypeReview],
                                       @"contentId":@"abcdef",
                                       @"detail1":@"Positive"};
    
    BVFeatureUsedEvent *feedbackEvent = [[BVFeatureUsedEvent alloc] initWithProductId:@"12345"
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
    XCTAssertTrue(contains, "Were the extra params for the profile added correctly?");

    [self checkCommonEventParams:eventDict];
    
    [BVPixel trackEvent:feedbackEvent];
    
    [self waitForAnalytics];
}

-(void)testUsedFeatureFeedbackInappropriate {
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *additionalParams = @{@"contentType":[BVPixelImpressionContentTypeUtil toString:BVPixelImpressionContentTypeQuestion],
                                       @"contentId":@"abcdef",
                                       @"detail1":@"Inappropriate"};
    
    BVFeatureUsedEvent *feedbackEvent = [[BVFeatureUsedEvent alloc] initWithProductId:@"12345"
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
    XCTAssertTrue(contains, "Were the extra params for the profile added correctly?");
    
    [self checkCommonEventParams:eventDict];
    
    [BVPixel trackEvent:feedbackEvent];
    
    [self waitForAnalytics];
    
}

-(void)testInViewEvent {
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSDictionary *testValues = @{@"productId":@"12345",
                                 @"bvProduct":@"RatingsAndReviews",
                                 @"name":@"InView",
                                 @"component":@"ReviewsTableView"
                                 };

    
    BVInViewEvent *inViewEvent = [[BVInViewEvent alloc] initWithProductId:[testValues objectForKey:@"productId"] withBrand:nil withProductType:BVPixelProductTypeConversationsReviews withContainerId:[testValues objectForKey:@"component"] withAdditionalParams:nil];
    
    NSDictionary *eventDict = [inViewEvent toRaw];
    
    // Test the required schema is defined correctly
    BOOL contains = [eventDict containsDictionary:FEATURE_USED_INVIEW_SCHEMA];
    XCTAssertTrue(contains, "Does the default schema exist for this product?");
    
    // Test the required schema is defined correctly
    contains = [eventDict containsDictionary:testValues];
    XCTAssertTrue(contains, "Are all the test values added to the event properly?");
    
    [self checkCommonEventParams:eventDict];
    
    [BVPixel trackEvent:inViewEvent];
    
    [self waitForAnalytics];
    
}


- (void)testTransactionConversionNoPII{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSArray* orderItems = @[[[BVTransactionItem alloc]initWithSku:@"123" name:@"test product" category:@"home and garden" price:99.99 quantity:1 imageUrl:nil]];
    BVTransactionEvent *transaction = [[BVTransactionEvent alloc]initWithOrderId:@"testorderid" orderTotal:99.99 orderItems:orderItems andOtherParams:@{@"state":@"TX", @"city": @"Austin"}];
    
    
    [self checkCommonEventParams:[transaction toRaw]];
    [self checkCommonEventParams:[transaction toRawNonPII]];
    
    [BVPixel trackEvent:transaction];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 1, @"Conversions without PII should only produce one event");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
}

- (void)testTransactionConversionPII{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    NSArray* orderItems = @[[[BVTransactionItem alloc]initWithSku:@"123" name:@"test product" category:@"home and garden" price:99.99 quantity:1 imageUrl:nil]];
    BVTransactionEvent *transaction = [[BVTransactionEvent alloc]initWithOrderId:@"testorderid" orderTotal:99.99 orderItems:orderItems andOtherParams:@{@"state":@"TX", @"city": @"Austin",
               /*PII*/   @"email":@"some.one@domain.com"}];
    
    
    NSDictionary *transactionPIIDict = [transaction toRaw];
    NSDictionary *transactionNoPII = [transaction toRawNonPII];
    
    [self checkCommonEventParams:transactionPIIDict];  //PII is in event, but IDFA is removed
    [self checkCommonEventParams:transactionNoPII];    // PII is not in the event and IDFA is present
    
    // Default event that has PII (e.g. email) will have set idfa to nontracking
    XCTAssertTrue([[transactionPIIDict objectForKey:@"advertisingId"] isEqualToString:@"nontracking"]);
    XCTAssertTrue([[transactionPIIDict objectForKey:@"hadPII"] isEqualToString:@"true"]);
    XCTAssertTrue([[transactionPIIDict objectForKey:@"email"] isEqualToString:@"some.one@domain.com"]);
    
    // For the nonPII-created dict, the email would be stripped but idfa presetn
    XCTAssertNil([transactionNoPII objectForKey:@"email"]);
    XCTAssertTrue([[transactionNoPII objectForKey:@"hadPII"] isEqualToString:@"true"]);
    XCTAssertFalse([[transactionNoPII objectForKey:@"advertisingId"] isEqualToString:@"nontracking"]);
    
    [BVPixel trackEvent:transaction];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 2, @"Conversions with PII should produce two events");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
    
}

- (void)testNonTransactionConversionNoPII{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    BVConversionEvent *conversion = [[BVConversionEvent alloc]initWithType:@"Broucher Download" value:@"HotSpringsSpas" label:@"TestLabel" otherParams:@{@"state":@"TX", @"city": @"Austin"}];
    
    [self checkCommonEventParams:[conversion toRaw]];
    [self checkCommonEventParams:[conversion toRawNonPII]];
    
    [BVPixel trackEvent:conversion];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 1, @"Non-transactional Conversions without PII should only produce one event");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
}

- (void)testNonTransactionConversionPII{
    
#if ANALYTICS_TEST_USING_MOCK_DATA == 1
    [self addStubWith200ResponseForJSONFileNamed:@"emptyJSON.json"];
#endif
    
    numberOfExpectedImpressionAnalyticsEvents = 1;
    numberOfExpectedPageviewAnalyticsEvents = 0;
    
    BVConversionEvent *conversion = [[BVConversionEvent alloc]initWithType:@"Broucher Download" value:@"HotSpringsSpas" label:@"TestLabel" otherParams:@{@"state":@"TX", @"city": @"Austin",
         /*PII*/      @"email":@"some.one@domain.com"}];
    
    NSDictionary *conversionPIIDict = [conversion toRaw];
    NSDictionary *conversionNoPII = [conversion toRawNonPII];
    
    [self checkCommonEventParams:conversionPIIDict];  //PII is in event, but IDFA is removed
    [self checkCommonEventParams:conversionNoPII];    // PII is not in the event and IDFA is present
    
    // Default event that has PII (e.g. email) will have set idfa to nontracking
    XCTAssertTrue([[conversionPIIDict objectForKey:@"advertisingId"] isEqualToString:@"nontracking"]);
    XCTAssertTrue([[conversionPIIDict objectForKey:@"hadPII"] isEqualToString:@"true"]);
    XCTAssertTrue([[conversionPIIDict objectForKey:@"email"] isEqualToString:@"some.one@domain.com"]);
    
    // For the nonPII-created dict, the email would be stripped but idfa presetn
    XCTAssertNil([conversionNoPII objectForKey:@"email"]);
    XCTAssertTrue([[conversionNoPII objectForKey:@"hadPII"] isEqualToString:@"true"]);
    XCTAssertFalse([[conversionNoPII objectForKey:@"advertisingId"] isEqualToString:@"nontracking"]);
    
    [BVPixel trackEvent:conversion];
    
    XCTAssert([[BVAnalyticsManager sharedManager]eventQueue].count == 2, @"Non-transactional Conversions with PII should produce two events");
    
    [[BVAnalyticsManager sharedManager] flushQueue];
    
    [self waitForAnalytics];
}


@end

