//
//  BVUASSubmission.m
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVUASSubmission.h"
#import "BVCommon.h"
#import "BVDiagnosticHelpers.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import "BVUASSubmissionErrorResponse.h"
#import "BVUASSubmissionResponse.h"

@interface BVUASSubmission ()
@property(nonnull, strong, nonatomic, readwrite) NSString *bvAuthToken;
@end

@implementation BVUASSubmission

@dynamic action;

- (nonnull instancetype)initWithBvAuthToken:(nonnull NSString *)bvAuthToken {
  if ((self = [super init])) {
    self.bvAuthToken = bvAuthToken ?: @"";
  }
  return self;
}

- (void)submit:(nonnull UASSubmissionCompletion)success
       failure:(nonnull ConversationsFailureHandler)failure {
  NSDictionary *parameters = [self createUASSubmissionParameters];
  NSData *postBody = [self transformToPostBody:parameters];

  NSString *urlString =
      [NSString stringWithFormat:@"%@authenticateuser.json",
                                 [BVConversationsRequest commonEndpoint]];
  NSURL *url = [NSURL URLWithString:urlString];

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:postBody];

  [[BVLogger sharedLogger]
      verbose:[NSString stringWithFormat:@"POST: %@\n with BODY: %@", urlString,
                                         parameters]];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *postDataTask = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *httpError) {

          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)
              response; // This dataTask is used with only HTTP requests.
          NSInteger statusCode = httpResponse.statusCode;
          NSError *jsonParsingError = nil;
          NSDictionary *json = nil;

          @try {
            json = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions
                                                     error:&jsonParsingError];

          } @catch (NSException *exception) {
            NSError *unknownError =
                [NSError errorWithDomain:BVErrDomain
                                    code:BV_ERROR_UNKNOWN
                                userInfo:@{
                                  NSLocalizedDescriptionKey :
                                      @"An unknown parsing error occurred."
                                }];

            [self sendError:unknownError failureCallback:failure];
            return;
          }

          [[BVLogger sharedLogger]
              verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json,
                                                 (long)statusCode]];

          if (httpError) {
            // network error was generated
            [self sendError:httpError failureCallback:failure];
            return;
          }

          if (statusCode >= 300) {
            // HTTP status code indicates failure
            NSError *statusError = [NSError
                errorWithDomain:BVErrDomain
                           code:BV_ERROR_NETWORK_FAILED
                       userInfo:@{
                         NSLocalizedDescriptionKey : @"Photo upload failed."
                       }];
            [self sendError:statusError failureCallback:failure];
            return;
          }

          if (jsonParsingError) {
            // json parsing failed
            [self sendError:jsonParsingError failureCallback:failure];
            return;
          }

          BVUASSubmissionErrorResponse *errorResponse =
              [[BVUASSubmissionErrorResponse alloc]
                  initWithApiResponse:json]; // fails gracefully

          if (errorResponse) {
            // api returned successfully, but has bazaarvoice-specific
            // errors. Example: 'invalid api key'
            [self sendErrors:[errorResponse toNSErrors]
                failureCallback:failure];
            return;
          }

          // success!
          BVUASSubmissionResponse *submissionResponse =
              [[BVUASSubmissionResponse alloc] initWithApiResponse:json];
          dispatch_async(dispatch_get_main_queue(), ^{
            success(submissionResponse);
          });

        }];

  // start submission for UAS
  [postDataTask resume];
}

- (nonnull NSDictionary *)createUASSubmissionParameters {
  NSMutableDictionary *parameters =
      [NSMutableDictionary dictionaryWithDictionary:@{
        @"apiversion" : @"5.4",
        @"authtoken" : self.bvAuthToken
      }];

  parameters[@"passkey"] =
      [BVSDKManager sharedManager].configuration.apiKeyConversations;
  parameters[@"_appId"] = [NSBundle mainBundle].bundleIdentifier;
  parameters[@"_appVersion"] = [BVDiagnosticHelpers releaseVersionNumber];
  parameters[@"_buildNumber"] = [BVDiagnosticHelpers buildVersionNumber];
  parameters[@"_bvIosSdkVersion"] = BV_SDK_VERSION;

  return parameters;
}

@end
