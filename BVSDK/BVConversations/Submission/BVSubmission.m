//
//  BVSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVSubmission.h"
#import "BVLogger.h"

@interface BVSubmission ()
@end

@implementation BVSubmission

- (instancetype)init {
  return ((self = [super init]));
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

- (nonnull NSData *)transformToPostBody:(nonnull NSDictionary *)parameters {

  NSMutableArray *queryItems = [NSMutableArray array];

  parameters = [self urlEncodeParameters:parameters];

  for (NSString *key in parameters) {
    [queryItems
        addObject:[NSURLQueryItem queryItemWithName:key value:parameters[key]]];
  }

  NSURLComponents *components =
      [NSURLComponents componentsWithString:@"http://bazaarvoice.com"];
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

@end
