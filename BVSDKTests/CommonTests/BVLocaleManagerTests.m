//
//  BVLocaleManagerTests.m
//  BVSDKTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <BVSDK/BVAnalyticsManager+Testing.h>
#import <BVSDK/BVLocaleServiceManager.h>
#import <BVSDK/BVSDKConfiguration.h>
#import <BVSDK/BVSDKManager.h>

#import "BVBaseStubTestCase.h"

static NSString *configuredLocaleIdentifier;
static NSString *nonEUProductionValue;
static NSString *nonEUStagingValue;
static NSString *euProductionValue;
static NSString *euStagingValue;

@interface BVLocaleManagerTests : XCTestCase
@end

@implementation BVLocaleManagerTests

- (void)setUp {
  [super setUp];

  nonEUProductionValue = @"https://network.bazaarvoice.com/event";
  nonEUStagingValue = @"https://network-stg.bazaarvoice.com/event";
  euProductionValue = @"https://network-eu.bazaarvoice.com/event";
  euStagingValue = @"https://network-eu-stg.bazaarvoice.com/event";

  configuredLocaleIdentifier = @"en_GB";
  [[BVAnalyticsManager sharedManager] setFlushInterval:0.1];

  NSDictionary *configDict = @{
    @"clientId" : @"mobileBVPixelTestsiOS",
    @"analyticsLocaleIdentifier" : configuredLocaleIdentifier
  };

  [BVSDKManager configureWithConfiguration:configDict
                                configType:BVConfigurationTypeProd];

  [[BVSDKManager sharedManager] setLogLevel:BVLogLevelAnalyticsOnly];
}

- (void)tearDown {
  [super tearDown];
}

#pragma mark - BVLocaleServiceManagerServiceAnalytics

- (void)testAnalyticsLocaleConfiguration {
  NSLocale *greatBritainLocale =
      [[NSLocale alloc] initWithLocaleIdentifier:configuredLocaleIdentifier];
  NSLocale *currentLocale = [BVAnalyticsManager sharedManager].analyticsLocale;

  XCTAssertEqualObjects(greatBritainLocale, currentLocale,
                        @"Configured Locale not equal to Generated Locale");

  /// Reset, just in case.
  configuredLocaleIdentifier = nil;
}

- (void)testAnalyticsLocaleForEU {

  NSLocale *currentLocale = [BVAnalyticsManager sharedManager].analyticsLocale;

  NSString *stagingResource = [[BVLocaleServiceManager sharedManager]
      resourceForService:BVLocaleServiceManagerServiceAnalytics
              withLocale:currentLocale
         andIsProduction:NO];
  XCTAssertEqualObjects(stagingResource, euStagingValue,
                        @"Staging resource doesn't match proper resource URL");

  NSString *productionResource = [[BVLocaleServiceManager sharedManager]
      resourceForService:BVLocaleServiceManagerServiceAnalytics
              withLocale:currentLocale
         andIsProduction:YES];
  XCTAssertEqualObjects(
      productionResource, euProductionValue,
      @"Production resource doesn't match proper resource URL");

  /// Reset, just in case.
  configuredLocaleIdentifier = nil;
}

- (void)testAnalyticsLocaleUpdate {
  XCTestExpectation *updateExpectation =
      [self expectationWithDescription:@"testAnalyticsLocaleUpdate"];

  NSLocale *currentLocale = [NSLocale autoupdatingCurrentLocale];
  [BVAnalyticsManager sharedManager].analyticsLocale = nil;

  [[NSNotificationCenter defaultCenter]
      postNotificationName:NSCurrentLocaleDidChangeNotification
                    object:nil];

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        NSLocale *updatedLocale =
            [BVAnalyticsManager sharedManager].analyticsLocale;
        XCTAssertEqualObjects(updatedLocale, currentLocale,
                              @"Updated Locale not equal to Generated Locale");
        [updateExpectation fulfill];
      });

  [self waitForExpectations:@[ updateExpectation ] timeout:6.0f];

  /// Reset, just in case.
  configuredLocaleIdentifier = nil;
}

- (void)testAnalyticsLocaleRoutingEfficacy {

  BVLocaleServiceManager *localeServiceManager =
      [BVLocaleServiceManager sharedManager];
  XCTAssertNotNil(localeServiceManager, @"localeServiceManager is nil");

  NSArray<NSString *> *nonEuCountries = @[
    @"en_US", @"en_AU", @"es_CL", @"en_PH", @"fil_PH", @"ru_UA", @"ru_RU",
    @"fr_CA", @"en_CA", @"pa_Guru_IN", @"en_IN", @"zh_Hans_SG"
  ];

  NSArray<NSString *> *euCountries = @[
    @"de_AT",  // Austria
    @"fr_BE",  // French (Belgium)
    @"de_BE",  // German (Belgium)
    @"bg_BG",  // Bulgaria
    @"fr_CH",  // Switzerland
    @"de_CH",  // Switzerland
    @"it_CH",  // Switzerland
    @"rm_CH",  // Switzerland
    @"gsw_CH", // Switzerland
    @"el_CY",  // Republic of Cyprus
    @"cs_CZ",  // Czech Republic
    @"de_DE",  // Germany
    @"da_DK",  // Denmark
    @"gl_ES",  // Spain
    @"ca_ES",  // Spain
    @"es_ES",  // Spain
    @"eu_ES",  // Spain
    @"et_EE",  // Estonia
    @"sv_FI",  // Finland
    @"fi_FI",  // Finland
    @"fr_FR",  // France
    @"cy_GB",  // Great Britain / UK
    @"gv_GB",  // Great Britain / UK
    @"en_GB",  // Great Britain / UK
    @"kw_GB",  // Great Britain / UK
    @"el_GR",  // Greece
    @"hr_HR",  // Croatia
    @"hu_HU",  // Hungary
    @"en_IE",  // Ireland
    @"ga_IE",  // Ireland
    @"is_IS",  // Iceland
    @"it_IT",  // Italy
    @"de_LI",  // Liechtenstein
    @"lt_LT",  // Lithuania
    @"fr_LU",  // Luxembourg
    @"de_LU",  // Luxembourg
    @"lv_LV",  // Latvia
    @"en_MT",  // Malta
    @"mt_MT",  // Malta
    @"nl_NL",  // Netherlands
    @"nn_NO",  // Norway
    @"nb_NO",  // Norway
    @"pl_PL",  // Poland
    @"pt_PT",  // Portugal
    @"ro_RO",  // Romania
    @"sv_SE",  // Sweden
    @"sl_SI",  // Slovenia
    @"sk_SK"   // Slovakia
  ];

  for (NSString *locale in nonEuCountries) {
    NSLocale *nonEULocal = [[NSLocale alloc] initWithLocaleIdentifier:locale];
    XCTAssertNotNil(nonEULocal, @"Non-EU Locale is nil: %@", nonEULocal);

    NSString *nonEUProduction = [localeServiceManager
        resourceForService:BVLocaleServiceManagerServiceAnalytics
                withLocale:nonEULocal
           andIsProduction:YES];

    XCTAssertEqualObjects(nonEUProduction, nonEUProductionValue,
                          @"Non-EU production values don't match: %@", locale);

    NSString *nonEUStaging = [localeServiceManager
        resourceForService:BVLocaleServiceManagerServiceAnalytics
                withLocale:nonEULocal
           andIsProduction:NO];

    XCTAssertEqualObjects(nonEUStaging, nonEUStagingValue,
                          @"EU staging values don't match: %@", locale);
  }

  for (NSString *locale in euCountries) {
    NSLocale *euLocale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
    XCTAssertNotNil(euLocale, @"EU Locale is nil: %@", euLocale);

    NSString *euProduction = [localeServiceManager
        resourceForService:BVLocaleServiceManagerServiceAnalytics
                withLocale:euLocale
           andIsProduction:YES];

    XCTAssertEqualObjects(euProduction, euProductionValue,
                          @"EU production values don't match: %@", locale);

    NSString *euStaging = [localeServiceManager
        resourceForService:BVLocaleServiceManagerServiceAnalytics
                withLocale:euLocale
           andIsProduction:NO];

    XCTAssertEqualObjects(euStaging, euStagingValue,
                          @"EU staging values don't match: %@", locale);
  }
}

@end
