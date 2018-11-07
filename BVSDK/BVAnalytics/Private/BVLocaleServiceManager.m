//
//  BVLocaleServiceManager.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVLocaleServiceManager.h"
#import "BVLogger+Private.h"
#import "BVNullHelper.h"

/// If we have to expand this we will rethink how we package all these fields
/// it's just that we don't have any other examples in order to determine a
/// proper course of action.

/// Top level Keys/Constants
#define BV_LOCALE_SERVICE_MANAGER_RESOURCE_PRODUCTION @"production"
#define BV_LOCALE_SERVICE_MANAGER_RESOURCE_STAGING @"staging"
#define BV_LOCALE_SERVICE_MANAGER_RESOURCE_DEFAULT @"default"
#define BV_LOCALE_SERVICE_MANAGER_RESOURCE_VALUES @"values"
#define BV_LOCALE_SERVICE_MANAGER_RESOURCE_MAPPINGS @"mappings"

/// BVAnalytics Keys/Constants
#define BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE @"bvanalytics"
#define BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_DEFAULT                    \
  BV_LOCALE_SERVICE_MANAGER_RESOURCE_DEFAULT
#define BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU @"EU"

/// Magpie Resource URLs
#define BV_MAGPIE_ENDPOINT @"https://network.bazaarvoice.com/event"
#define BV_MAGPIE_STAGING_ENDPOINT @"https://network-stg.bazaarvoice.com/event"
#define BV_MAGPIE_EU_ENDPOINT @"https://network-eu.bazaarvoice.com/event"
#define BV_MAGPIE_EU_STAGING_ENDPOINT                                          \
  @"https://network-eu-stg.bazaarvoice.com/event"

@implementation BVLocaleServiceManager

__strong static BVLocaleServiceManager *localeManagerInstance = nil;
+ (nonnull instancetype)sharedManager {
  static dispatch_once_t localeSharedManagerOnceToken;
  dispatch_once(&localeSharedManagerOnceToken, ^{
    localeManagerInstance = [[self alloc] init];
  });
  return localeManagerInstance;
}

+ (nullable NSString *)serviceToIdentifier:
    (BVLocaleServiceManagerService)service {
  NSString *identifier = nil;
  switch (service) {
  case BVLocaleServiceManagerServiceAnalytics:
    identifier = BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE;
    break;
  default:
    break;
  }
  return identifier;
}

__strong static NSDictionary *resourceDictionary = nil;
+ (nonnull NSDictionary *)localeResourceDictionary {
  static dispatch_once_t resourceDictionaryOnceToken;
  dispatch_once(&resourceDictionaryOnceToken, ^{
    resourceDictionary = @{
      BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE : @{

        BV_LOCALE_SERVICE_MANAGER_RESOURCE_VALUES : @{
          BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_DEFAULT : @{
            BV_LOCALE_SERVICE_MANAGER_RESOURCE_PRODUCTION : BV_MAGPIE_ENDPOINT,
            BV_LOCALE_SERVICE_MANAGER_RESOURCE_STAGING :
                BV_MAGPIE_STAGING_ENDPOINT
          },
          BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU : @{
            BV_LOCALE_SERVICE_MANAGER_RESOURCE_PRODUCTION :
                BV_MAGPIE_EU_ENDPOINT,
            BV_LOCALE_SERVICE_MANAGER_RESOURCE_STAGING :
                BV_MAGPIE_EU_STAGING_ENDPOINT
          }
        },

        BV_LOCALE_SERVICE_MANAGER_RESOURCE_MAPPINGS : @{
          BV_LOCALE_SERVICE_MANAGER_RESOURCE_DEFAULT :
              BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_DEFAULT,
          @"AT" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Austria
          @"BE" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Belgium
          @"BG" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Bulgaria
          @"CH" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Switzerland
          @"CY" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Republic of
                                                                  // Cyprus
          @"CZ" :
              BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Czech Republic
          @"DE" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Germany
          @"DK" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Denmark
          @"ES" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Spain
          @"EE" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Estonia
          @"FI" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Finland
          @"FR" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // France
          @"GB" :
              BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Great Britain
                                                              // / UK
          @"GR" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Greece
          @"HR" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Croatia
          @"HU" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Hungary
          @"IE" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Ireland
          @"IS" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Iceland
          @"IT" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Italy
          @"LI" :
              BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Liechtenstein
          @"LT" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Lithuania
          @"LU" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Luxembourg
          @"LV" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Latvia
          @"MT" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Malta
          @"NL" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Netherlands
          @"NO" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Norway
          @"PL" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Poland
          @"PT" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Portugal
          @"RO" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Romania
          @"SE" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Sweden
          @"SI" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU, // Slovenia
          @"SK" : BV_LOCALE_SERVICE_MANAGER_ANALYTICS_SERVICE_EU  // Slovakia
        }
      }
    };
  });

  return resourceDictionary;
}

- (nonnull NSString *)resourceForService:(BVLocaleServiceManagerService)service
                              withLocale:(nonnull NSLocale *)locale
                         andIsProduction:(BOOL)isProduction {

  NSString *resource = @"";

  /// Validate BVLocaleServiceManagerService parameter
  NSString *serviceValue = [[self class] serviceToIdentifier:service];
  NSAssert(serviceValue, @"Service Value is nil, please check that the "
                         @"mappings are acccurate with the service local "
                         @"dictionary.");
  if (!serviceValue) {
    return resource;
  }

  /// Validate that a valid locale object is acquired
  NSAssert(locale, @"A valid local object must be passed in.");
  if (!locale) {
    return resource;
  }

  id localeObject = [locale objectForKey:NSLocaleCountryCode];
  NSString *localeIdentifier = (__IS_KIND_OF(localeObject, NSString))
                                   ? ((NSString *)localeObject).uppercaseString
                                   : nil;
  NSAssert(localeIdentifier,
           @"This should have received a valid locale identifier, %@", locale);
  if (!localeIdentifier) {
    return resource;
  }

  /// Validate localeResourceDictionary pieces
  NSDictionary *resourceDictionary = [[self class] localeResourceDictionary];
  NSAssert(resourceDictionary, @"Resource dictionary shouldn't be nil.");
  if (!resourceDictionary) {
    return resource;
  }

  /// Validate the specific service dictionary we're querying
  id serviceObj = [resourceDictionary objectForKey:serviceValue];
  NSDictionary *serviceDictionary = (__IS_KIND_OF(serviceObj, NSDictionary))
                                        ? (NSDictionary *)serviceObj
                                        : nil;
  NSAssert(serviceDictionary, @"Service dictionary shouldn't be nil.");
  if (!serviceDictionary) {
    return resource;
  }

  /// Validate the service values dictionary
  id valuesObj = [serviceDictionary
      objectForKey:BV_LOCALE_SERVICE_MANAGER_RESOURCE_VALUES];
  NSDictionary *valuesDict =
      (__IS_KIND_OF(valuesObj, NSDictionary)) ? (NSDictionary *)valuesObj : nil;
  NSAssert(valuesDict, @"Values dictionary shouldn't be nil.");
  if (!valuesDict) {
    return resource;
  }

  /// Validate the service mappings dictionary
  id mappingsObj = [serviceDictionary
      objectForKey:BV_LOCALE_SERVICE_MANAGER_RESOURCE_MAPPINGS];
  NSDictionary *mappingsDict = (__IS_KIND_OF(mappingsObj, NSDictionary))
                                   ? (NSDictionary *)mappingsObj
                                   : nil;
  NSAssert(mappingsDict, @"Mappings dictionary shouldn't be nil.");
  if (!mappingsDict) {
    return resource;
  }

  /// Check to see if we have a mapping or we need to jump to a default
  id map = [mappingsDict objectForKey:localeIdentifier]
               ?: BV_LOCALE_SERVICE_MANAGER_RESOURCE_DEFAULT;

  /// Grab the proper specfic value dictionary
  id valueObj = [valuesDict objectForKey:map];
  NSDictionary *valueDict =
      (__IS_KIND_OF(valueObj, NSDictionary)) ? (NSDictionary *)valueObj : nil;
  NSAssert(valueDict, @"Value dictionary shouldn't be nil.");
  if (!valueDict) {
    return resource;
  }

  id environmentKey = isProduction
                          ? BV_LOCALE_SERVICE_MANAGER_RESOURCE_PRODUCTION
                          : BV_LOCALE_SERVICE_MANAGER_RESOURCE_STAGING;

  id resourceObj = [valueDict objectForKey:environmentKey];
  NSString *value =
      (__IS_KIND_OF(resourceObj, NSString)) ? (NSString *)resourceObj : nil;
  NSAssert(value, @"No proper value for environment key.");
  if (!value) {
    return resource;
  } else {
    resource = value;
  }

  BVLogAnalytics(
      ([NSString
          stringWithFormat:@"Analytics using Locale: %@ for resource: %@",
                           localeIdentifier, resource]),
      BV_PRODUCT_ANALYTICS);

  return resource;
}

@end
