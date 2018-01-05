//
//  BVCurationsPhotoUploader.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsPhotoUploader.h"
#import "BVCurations.h"
#import "BVSDKConfiguration.h"

@implementation BVCurationsPhotoUploader

- (void)submitCurationsContentWithParams:(BVCurationsAddPostRequest *)postParams
                       completionHandler:
                           (uploadCompletionHandler)completionHandler
                             withFailure:(uploadErrorHandler)failureHandler {
  NSString *clientId = [BVSDKManager sharedManager].configuration.clientId;
  NSString *passKey =
      [BVSDKManager sharedManager].configuration.apiKeyCurations;

  NSAssert(passKey && 0 < passKey.length, @"apiKeyCurations is required!");

  if (!postParams) {
    NSDictionary *userInfo = @{
      NSLocalizedDescriptionKey : @"Required parameter postParams was nil."
    };
    NSError *err =
        [NSError errorWithDomain:BVErrDomain code:-1 userInfo:userInfo];

    [self errorOnMainThread:err handler:failureHandler];
  }

  NSString *endPoint = [NSString
      stringWithFormat:@"%@/curations/content/add/?client=%@&passkey=%@",
                       [self urlRootCurations], clientId, passKey];
  NSURLSessionConfiguration *config =
      [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
  NSURL *url = [NSURL URLWithString:endPoint];

  NSString *boundary = [self generateBoundaryString];

  // Create and configure the request

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];

  // Set the content type

  NSString *contentType =
      [NSString stringWithFormat:@"multipart/form-data; Boundary=%@", boundary];
  [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

  // create body

  NSData *httpBody =
      [self createBodyWithBoundary:boundary withRequestParams:postParams];

  [[BVLogger sharedLogger]
      verbose:[NSString stringWithFormat:@"POST: %@ with BODY: %@", request,
                                         postParams.description]];

  NSURLSessionUploadTask *taskUpload = [session
      uploadTaskWithRequest:request
                   fromData:httpBody
          completionHandler:^(NSData *__nullable data,
                              NSURLResponse *__nullable response,
                              NSError *__nullable error) {

            // completion
            if (error) {
              // Error from the task itself
              [[BVLogger sharedLogger]
                  error:[NSString stringWithFormat:@"ERROR: %@",
                                                   error.localizedDescription]];

              [self errorOnMainThread:error handler:failureHandler];
              return;
            }

            NSError *errorJSON;
            NSDictionary *responseDict =
                [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&errorJSON];

            if (!errorJSON) {
              NSInteger status = [self getStatusCodeFromResponse:responseDict];
              if (status < 299) {
                [[BVLogger sharedLogger]
                    verbose:[NSString
                                stringWithFormat:@"Result: %@", responseDict]];

                // success
                [self completionOnMainThreadWithHandler:completionHandler];

              } else {
                // fail
                NSString *errorString =
                    [self getErrorStringFromResponse:responseDict];

                if (!errorString) {
                  errorString = @"Unknown error from server.";
                }

                NSDictionary *userInfo =
                    @{NSLocalizedDescriptionKey : errorString};
                NSError *err = [NSError errorWithDomain:BVErrDomain
                                                   code:status
                                               userInfo:userInfo];

                [[BVLogger sharedLogger]
                    error:[NSString stringWithFormat:@"ERROR: %@",
                                                     err.localizedDescription]];

                [self errorOnMainThread:err handler:failureHandler];

                return;
              }

            } else {
              // json serialization error
              [[BVLogger sharedLogger]
                  error:[NSString stringWithFormat:
                                      @"ERROR: JSON Seriazation Error: %@",
                                      error.localizedDescription]];

              NSDictionary *userInfo =
                  @{NSLocalizedDescriptionKey : @"JSON Serialization Error"};
              NSError *err = [NSError errorWithDomain:BVErrDomain
                                                 code:-1
                                             userInfo:userInfo];

              [self errorOnMainThread:err handler:failureHandler];
            }

          }];

  [taskUpload resume];
}

- (void)completionOnMainThreadWithHandler:
    (uploadCompletionHandler)completionHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
    completionHandler();
  });
}

- (void)errorOnMainThread:(NSError *)error
                  handler:(uploadErrorHandler)errorHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
    errorHandler(error);
  });
}

// Response code may be in either 'status' or 'code' as an integer
- (NSInteger)getStatusCodeFromResponse:(NSDictionary *)response {
  long status = 200; // presume success unless we can dig out the exact failure

  if ([response objectForKey:@"code"] != nil &&
      [[response objectForKey:@"code"] isKindOfClass:[NSNumber class]]) {
    // found integer in "code"
    status = [[response objectForKey:@"code"] integerValue];

  } else if ([response objectForKey:@"status"] != nil &&
             [[response objectForKey:@"status"]
                 isKindOfClass:[NSNumber class]]) {
    // found integer in "status"
    status = [[response objectForKey:@"status"] integerValue];
  }

  return status;
}

- (NSString *)getErrorStringFromResponse:(NSDictionary *)response {
  NSString *errorString = nil;
  if ([response objectForKey:@"detail"] != nil) {
    errorString = [response objectForKey:@"detail"];
  } else if ([response objectForKey:@"status"] != nil &&
             [[response objectForKey:@"status"]
                 isKindOfClass:[NSString class]]) {
    errorString = [response objectForKey:@"status"];
  }

  return errorString;
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                 withRequestParams:(BVCurationsAddPostRequest *)request {
  NSMutableData *httpBody = [NSMutableData data];

  // add params

  if (request) {
    // We need to send string representation in the body for the API to
    // parse the params
    NSString *jsonString =
        [[NSString alloc] initWithData:request.serializeParameters
                              encoding:NSUTF8StringEncoding];

    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: "
                                                     @"form-data; "
                                                     @"name=\"%@\"\r\n\r\n",
                                                     @"jsonpayload"]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody
        appendData:[[NSString stringWithFormat:@"%@\r\n", jsonString]
                       dataUsingEncoding:NSUTF8StringEncoding]]; // JSON
                                                                 // dictionary
  }

  // add image data, if present and there are no photo links
  if (request.image && request.photos.count == 0) {
    NSString *base64 = [self encodeToBase64String:request.image];
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: "
                                                     @"form-data; "
                                                     @"name=\"%@\"\r\n\r\n",
                                                     @"image"]
                             dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody
        appendData:[[NSString stringWithFormat:@"%@\r\n", base64]
                       dataUsingEncoding:NSUTF8StringEncoding]]; // JSON
                                                                 // dictionary
  }

  [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary]
                           dataUsingEncoding:NSUTF8StringEncoding]];

  return httpBody;
}

- (NSString *)encodeToBase64String:(UIImage *)image {
  return [UIImagePNGRepresentation(image)
      base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)generateBoundaryString {
  return [NSString stringWithFormat:@"Boundary+%@", [[NSUUID UUID] UUIDString]];
}

- (NSString *)urlRootCurations {
  return [BVSDKManager sharedManager].configuration.staging
             ? @"https://stg.api.bazaarvoice.com"
             : @"https://api.bazaarvoice.com";
}

@end
