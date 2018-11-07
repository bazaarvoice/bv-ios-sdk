//
//  BVSubmission.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVCommon.h"
#import "BVLogger+Private.h"
#import "BVNetworkingManager.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVStringKeyValuePair.h"
#import "BVSubmission+Private.h"

@interface BVSubmission ()
@property(nullable, nonatomic, readwrite)
    NSMutableArray<BVStringKeyValuePair *> *customFormPairs;
@end

@implementation BVSubmission

- (NSString *)conversationsKey {
  NSString *key =
      [BVSDKManager sharedManager].configuration.apiKeyConversations;
  NSAssert(key, @"Conversations key isn't configured");
  return key;
}

- (instancetype)init {
  if ((self = [super init])) {
    self.customFormPairs = [NSMutableArray array];
  }
  return self;
}

+ (nonnull NSString *)commonEndpoint {
  return [BVSDKManager sharedManager].configuration.staging
             ? @"https://stg.api.bazaarvoice.com/data/"
             : @"https://api.bazaarvoice.com/data/";
}

- (void)sendError:(nonnull NSError *)error
    failureCallback:(ConversationsFailureHandler)failure {
  [[BVLogger sharedLogger] printError:error];
  dispatch_async(dispatch_get_main_queue(), ^{
    failure(@[ error ]);
  });
}

- (void)sendErrors:(nonnull NSArray<NSError *> *)errors
    failureCallback:(ConversationsFailureHandler)failure {
  for (NSError *error in errors) {
    [[BVLogger sharedLogger] printError:error];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    failure(errors);
  });
}

- (void)sendResponse:(nonnull BVSubmissionResponse<BVSubmittedType *> *)response
     successCallback:
         (void (^__nonnull)(BVSubmissionResponse<BVSubmittedType *> *__nonnull))
             success {
  NSAssert(response, @"Subclass needs to return a valid BVSubmissionResponse!");
  dispatch_async(dispatch_get_main_queue(), ^{
    success(response);
  });
}

- (nonnull NSData *)transformToPostBody:(nonnull NSDictionary *)parameters {

  NSMutableArray *queryItems = [NSMutableArray array];

  parameters = [self urlEncodeParameters:parameters];

  for (NSString *key in parameters) {
    [queryItems
        addObject:[NSURLQueryItem queryItemWithName:key value:parameters[key]]];
  }

  NSURLComponents *components =
      [NSURLComponents componentsWithString:[BVSubmission commonEndpoint]];
  components.queryItems = queryItems;
  NSString *query = components.query;
  return [query dataUsingEncoding:NSUTF8StringEncoding];
}

static NSString *urlEncode(id object) {

  NSString *string = [NSString stringWithFormat:@"%@", object];

  NSMutableCharacterSet *chars =
      [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
  [chars removeCharactersInString:@"+&"];
  return [string stringByAddingPercentEncodingWithAllowedCharacters:chars];
}

- (NSDictionary *)urlEncodeParameters:(NSDictionary *)parameters {
  NSMutableDictionary *parts = [NSMutableDictionary dictionary];

  for (id key in parameters) {
    id value = [parameters objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
      for (NSString *valueString in value) {
        [parts setObject:urlEncode(valueString) forKey:urlEncode(key)];
      }
    } else if ([value isKindOfClass:[NSString class]]) {
      [parts setObject:urlEncode(value) forKey:urlEncode(key)];
    }
  }
  return parts;
}

- (void)addCustomSubmissionParameter:(nonnull NSString *)parameter
                           withValue:(nonnull NSString *)value {
  BVStringKeyValuePair *customFormPair =
      [BVStringKeyValuePair pairWithKey:parameter value:value];
  [self.customFormPairs addObject:customFormPair];
}

- (void)submit:(void (^__nonnull)(
                   BVSubmissionResponse<BVSubmittedType *> *__nonnull))success
       failure:(nonnull ConversationsFailureHandler)failure {

  NSURLRequest *request = [self generateRequest];

  NSURLSession *session = nil;
  id<BVURLSessionDelegate> sessionDelegate =
      [BVSDKManager sharedManager].urlSessionDelegate;
  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector(URLSessionForBVObject:)]) {
    session = [sessionDelegate URLSessionForBVObject:self];
  }

  session = session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSURLSessionDataTask *postDataTask = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *httpError) {

          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)
              response; // This dataTask is used with only HTTP requests.
          NSInteger statusCode = httpResponse.statusCode;
          NSError *jsonParsingError = nil;

          if (httpError) {
            [self sendError:httpError failureCallback:failure];
            return;
          }

          if (statusCode >= 300) {
            // HTTP status code indicates failure
            NSString *errorDescription =
                [NSString stringWithFormat:@"Unknown network error occurred, "
                                           @"HTTP Status Code : [%lu].",
                                           (unsigned long)statusCode];
            NSError *statusError =
                [NSError errorWithDomain:BVErrDomain
                                    code:BV_ERROR_NETWORK_FAILED
                                userInfo:@{
                                  NSLocalizedDescriptionKey : errorDescription
                                }];

            [self sendError:statusError failureCallback:failure];
            return;
          }

          if (!data) {
            NSError *error =
                [NSError errorWithDomain:BVErrDomain
                                    code:BV_ERROR_UNKNOWN
                                userInfo:@{
                                  NSLocalizedDescriptionKey :
                                      @"Submission failed. Unknown Transport "
                                      @"Layer Error. No Data."
                                }];

            [self sendError:error failureCallback:failure];
            return;
          }

          NSDictionary *json =
              [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&jsonParsingError];

          if (jsonParsingError) {
            // json parsing failed
            [self sendError:jsonParsingError failureCallback:failure];
            return;
          }

          BVLogVerbose(([NSString stringWithFormat:@"RESPONSE: %@", json]),
                       BV_PRODUCT_CONVERSATIONS);

          BVSubmissionErrorResponse *submissionErrorResponse =
              [self createErrorResponse:json]; // fails gracefully

          if (submissionErrorResponse) {
            NSArray<NSError *> *submissionErrors =
                [submissionErrorResponse toNSErrors];

            // api returned successfully, but has bazaarvoice-specific
            // errors. Example: 'invalid api key'
            [self sendErrors:submissionErrors failureCallback:failure];
            return;
          }

          // success!

          // Fire event now that we've confirmed it successfully uploaded.
          id<BVAnalyticEvent> event = [self trackEvent];
          if (event) {
            [BVPixel trackEvent:event];
          }

          // Craft and send the response
          BVSubmissionResponse *submissionResponse = [self createResponse:json];
          [self sendResponse:submissionResponse successCallback:success];
        }];

  // start uploading comment
  [postDataTask resume];

  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector
                       (URLSessionTask:fromBVObject:withURLSession:)]) {
    [sessionDelegate URLSessionTask:postDataTask
                       fromBVObject:self
                     withURLSession:session];
  }
}

- (nonnull NSString *)endpoint {
  NSAssert(NO, @"endpoint must be overridden by subclass");
  return nil;
}

- (nonnull NSURLRequest *)generateRequest {
  NSDictionary *parameters = [self createSubmissionParameters];
  NSData *postBody = [self transformToPostBody:parameters];

  NSString *urlString = [NSString
      stringWithFormat:@"%@%@", [BVSubmission commonEndpoint], [self endpoint]];
  NSURL *url = [NSURL URLWithString:urlString];

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:postBody];

  BVLogVerbose(([NSString stringWithFormat:@"POST: %@\n with BODY: %@",
                                           urlString, parameters]),
               BV_PRODUCT_CONVERSATIONS);

  return request;
}

- (nonnull NSDictionary *)createSubmissionParameters {
  __ASSERT_ISNT_A(self, BVSubmission,
                  @"createSubmissionParameters method should be overridden");

  NSMutableDictionary *parameters =
      [NSMutableDictionary dictionaryWithDictionary:@{
        @"apiversion" : @"5.4",
        @"passkey" : self.conversationsKey
      }];

  parameters[@"_appId"] = [NSBundle mainBundle].bundleIdentifier;
  parameters[@"_appVersion"] = [BVDiagnosticHelpers releaseVersionNumber];
  parameters[@"_buildNumber"] = [BVDiagnosticHelpers buildVersionNumber];
  parameters[@"_bvIosSdkVersion"] = BV_SDK_VERSION;

  for (BVStringKeyValuePair *keyValuePair in self.customFormPairs) {
    NSString *key = [keyValuePair key];
    NSString *value = [keyValuePair value];
    parameters[key] = value;
  }

  return parameters;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  NSAssert(NO, @"createResponse method should be overridden");
  return nil;
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  NSAssert(NO, @"createErrorResponse method should be overridden");
  return nil;
}

- (nullable id<BVAnalyticEvent>)trackEvent {
  NSAssert(NO, @"trackEvent method should be overridden");
  return nil;
}

@end
