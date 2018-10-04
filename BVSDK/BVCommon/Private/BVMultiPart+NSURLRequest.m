//
//  BVMultiPart+NSURLRequest.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVMultiPart+NSURLRequest.h"
#import "BVNullHelper.h"
#import "BVRandom+NSString.h"

#define BVFORM_BOUNDARY_RETRY_COUNT 10
#define BVFORM_BOUNDARY_LENGTH 20
#define BVFORM_BOUNDARY_PREFIX @"----------"
#define BVFORM_NSSTRING_BEGIN_WITH_BOUNDARY(X)                                 \
  [NSString stringWithFormat:@"--%@\r\n", (X)]
#define BVFORM_NSSTRING_CONTENT_TYPE_WITH_BOUNDARY(X)                          \
  [NSString stringWithFormat:@"multipart/form-data; boundary=%@", (X)]
#define BVFORM_NSSTRING_END_WITH_BOUNDARY(X)                                   \
  [NSString stringWithFormat:@"--%@--\r\n", (X)]
#define BVFORM_NSSTRING_FOR_KEY(X)                                             \
  [NSString                                                                    \
      stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", \
                       (X)]
#define BVFORM_NSSTRING_FOR_FILENAME(X)                                        \
  [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; "  \
                             @"filename=\"upload\"\r\n",                       \
                             (X)]
#define BVFORM_NSSTRING_FOR_FILE_CONTENT_TYPE                                  \
  @"Content-Type: application/octet-stream\r\n\r\n"
#define BVFORM_NSSTRING_TRAILER @"\r\n"

@implementation NSURLRequest (MultiPart)

+ (nullable NSString *)
generateBoundaryWithData:(nonnull NSMutableData *)bodyData
    andContentDictionary:(nonnull NSDictionary *)contentDictionary {
  NSString *boundary = nil;
  NSMutableArray<NSData *> *contentData = nil;

  // Checks for invalid input
  if (!bodyData || !contentDictionary) {
    return nil;
  }

  // No point attempting to send nothing
  if (0 == contentDictionary.count) {
    return nil;
  }

  contentData = [NSMutableArray arrayWithCapacity:contentDictionary.count];

  /*
   * Here we first build up an array of NSData blobs that contain the
   * encapsulated data in order. We when then use this to iterate through to
   * make sure that the randomly generated boundary doesn't exist in the data.
   */
  [contentDictionary
      enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj,
                                          BOOL *_Nonnull stop) {
        // It has to be a NSString key
        if (!__IS_KIND_OF(key, NSString)) {
          return;
        }

        // Can't have zero length key/filename
        NSString *keyString = (NSString *)key;
        if (0 == keyString.length) {
          return;
        }

        NSMutableData *data = [NSMutableData data];

        // For now we'll only support NSString and NSData values
        if (__IS_KIND_OF(obj, NSString)) {
          NSString *value = (NSString *)obj;
          [data appendData:[BVFORM_NSSTRING_FOR_KEY(keyString)
                               dataUsingEncoding:NSUTF8StringEncoding]];
          [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
          [data appendData:[BVFORM_NSSTRING_TRAILER
                               dataUsingEncoding:NSUTF8StringEncoding]];
          [contentData addObject:data];
          return;
        }

        if (__IS_KIND_OF(obj, NSData)) {
          NSData *value = (NSData *)obj;
          [data appendData:[BVFORM_NSSTRING_FOR_FILENAME(keyString)
                               dataUsingEncoding:NSUTF8StringEncoding]];
          [data appendData:[BVFORM_NSSTRING_FOR_FILE_CONTENT_TYPE
                               dataUsingEncoding:NSUTF8StringEncoding]];
          [data appendData:[NSData dataWithData:value]];
          [data appendData:[BVFORM_NSSTRING_TRAILER
                               dataUsingEncoding:NSUTF8StringEncoding]];
          [contentData addObject:data];
          return;
        }

      }];

  // Found nothing valid within the passed in dictionary
  if (0 == contentData.count) {
    return nil;
  }

  NSInteger tries = BVFORM_BOUNDARY_RETRY_COUNT;

  do {
    // Decrement the retry counter
    tries--;

    // Default state is "worked" since it should work 99.99999%
    __block BOOL itWorked = YES;

    // Build up random boundary string with prefix
    NSMutableString *candidate =
        [NSMutableString stringWithString:BVFORM_BOUNDARY_PREFIX];
    [candidate
        appendString:[NSString
                         randomHexStringWithLength:BVFORM_BOUNDARY_LENGTH]];

    // Search body data for subdata matching...
    NSData *candidateData = [candidate dataUsingEncoding:NSUTF8StringEncoding];
    [contentData
        enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx,
                                     BOOL *_Nonnull stop) {
          NSRange range = [obj rangeOfData:candidateData
                                   options:0
                                     range:NSMakeRange(0, [obj length])];
          if (range.location != NSNotFound) {
            itWorked = NO;
            *stop = YES;
          }
        }];

    // No match, success!
    if (itWorked) {
      boundary = candidate;
      break;
    }

    // I hope it works the next time :|
  } while (0 < tries);

  // Now to actually add the boundary to the data if we found a valid boundary
  if (boundary) {
    [contentData
        enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx,
                                     BOOL *_Nonnull stop) {
          [bodyData appendData:[BVFORM_NSSTRING_BEGIN_WITH_BOUNDARY(boundary)
                                   dataUsingEncoding:NSUTF8StringEncoding]];
          [bodyData appendData:obj];
        }];

    // Close it all up
    [bodyData appendData:[BVFORM_NSSTRING_END_WITH_BOUNDARY(boundary)
                             dataUsingEncoding:NSUTF8StringEncoding]];
  }

  return boundary;
}

@end
