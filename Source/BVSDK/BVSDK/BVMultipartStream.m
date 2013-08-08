//
//  BVMultipartStream.h
//  BVSDK
//
//
//  NSInputStream subclass which alows for streaming multipart post parameters
//
//  Created by Bazaarvoice Engineering on 11/27/12.
//
//  Copyright 2013 Bazaarvoice, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "BVMultipartStream.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface BVMultipartStreamParam : NSObject

@property (nonatomic, strong) NSMutableData * header;
@property (nonatomic, strong) NSInputStream * body;
@property (nonatomic, strong) NSMutableData * footer;

@property (readonly) uint length;
@property (nonatomic) uint bodyLength;
@property (nonatomic) uint bytesDelivered;

@end


@implementation BVMultipartStreamParam

- (uint)length
{
    return self.header.length + self.bodyLength + self.footer.length;
}

- (id)initWithKey:(NSString *)key value:(NSString *)value boundary:(NSString *)boundary
{
    self = [super init];
    if(self) {
        // Header is the multipart boundary
        self.header = [[NSMutableData alloc] init];
        [self.header appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [self.header appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
                                 dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Since this is just a text param, we'll just put the value in the "header" -- no body
        [self.header appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        self.bodyLength = 0;
        
        // Footer is just a return
        self.footer = [[NSMutableData alloc] init];
        [self.footer appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return self;
}

- (id)initWithKey:(NSString *)key data:(NSData *)value boundary:(NSString *)boundary filename:(NSString *)filename
{
    // Header is the multipart boundary
    self.header = [[NSMutableData alloc] init];
    [self.header appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.header appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.header appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    
    // Body is an input stream to read the NSData value
    self.body = [[NSInputStream alloc] initWithData:value];
    [self.body open];
    self.bodyLength = value.length;
    
    // Footer is just a return 
    self.footer = [[NSMutableData alloc] init];
    [self.footer appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return self;
}

- (id)initWithKey:(NSString *)key file:(NSURL *)value boundary:(NSString *)boundary filename:(NSString *)filename
{
    // Header is the multipart boundary
    self.header = [[NSMutableData alloc] init];
    [self.header appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.header appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.header appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Body is an input stream to read the NSData value
    self.body = [[NSInputStream alloc] initWithURL:value];
    [self.body open];
    self.bodyLength =  [[[NSFileManager defaultManager] attributesOfItemAtPath:value.absoluteString error:nil][NSFileSize] longLongValue];
    
    // Footer is just a return
    self.footer = [[NSMutableData alloc] init];
    [self.footer appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return self;
}

- (NSUInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)maxLength
{
    NSUInteger bytesSent = 0;
    NSInteger bytesRead = 0;
    
    if (self.bytesDelivered >= self.length) {
        return 0;
    }
    
    if (self.bytesDelivered < self.header.length && bytesSent < maxLength) {
        bytesRead = MIN(self.header.length - self.bytesDelivered, maxLength - bytesSent);
        [self.header getBytes:buffer + bytesSent range:NSMakeRange(self.bytesDelivered, bytesRead)];
        bytesSent += bytesRead;
        self.bytesDelivered += bytesSent;
    }

    while (self.bytesDelivered >= self.header.length && self.bytesDelivered < (self.header.length + self.bodyLength) && bytesSent < maxLength) {
        bytesRead = [self.body read:(buffer + bytesSent) maxLength:(maxLength - bytesSent)];
        if (bytesRead == 0) {
            break;
        } else if(bytesRead < 0) {
            NSLog(@"Something went wrong reading data");
        }
        bytesSent += bytesRead;
        self.bytesDelivered += bytesRead;
    }
    
    if (self.bytesDelivered >= (self.header.length + self.bodyLength) && bytesSent < maxLength) {
        uint bytesRemaining = self.header.length + self.bodyLength + self.footer.length - self.bytesDelivered;
        uint byteOffset = self.bytesDelivered - (self.header.length + self.bodyLength);
        bytesRead = MIN(bytesRemaining, maxLength - bytesSent);
        [self.footer getBytes:buffer + bytesSent range:NSMakeRange(byteOffset, bytesRead)];
        bytesSent += bytesRead;
        self.bytesDelivered += bytesRead;
    }
    
    return bytesSent;
}
@end

@interface BVMultipartStream()

@property (strong) NSString * boundary;
@property (strong) NSData *requestFooter;
@property (strong) NSMutableArray * multipartParams;
@property (readonly) NSStreamStatus streamStatus;
@property (nonatomic) uint bytesDelivered;

@end

@implementation BVMultipartStream

- (id)initWithParams:(NSDictionary *)params boundary:(NSString *)boundary sender:(id)sender {
    self = [super init];
    if(self) {
        self.boundary = boundary;
        self.requestFooter = [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
        self.bytesDelivered = 0;
        self.multipartParams = [[NSMutableArray alloc] init];
        [self addMultipartParams:params sender:sender];
    }
    return self;
}

- (void)addMultipartParams:(NSDictionary *)params sender:(id)sender {
    for (id key in params) {
        id value = [params objectForKey: key];
        if([value isKindOfClass:[NSArray class]]) {
            for(NSString * valueString in value){
                [self.multipartParams addObject:[[BVMultipartStreamParam alloc] initWithKey:key
                                                                                      value:valueString
                                                                                   boundary:self.boundary]];
            }
        } else if([value isKindOfClass:[NSString class]]) {
            [self.multipartParams addObject:[[BVMultipartStreamParam alloc] initWithKey:key
                                                                                  value:value
                                                                               boundary:self.boundary]];
        } else if([value isKindOfClass:[UIImage class]]) {
            UIImage * image = value;
            [self.multipartParams addObject:[[BVMultipartStreamParam alloc] initWithKey:key
                                                                                  data:UIImageJPEGRepresentation(image, 1.0)
                                                                               boundary:self.boundary
                                                                               filename:@"somefile"]];
        } else if([value isKindOfClass:[NSData class]]) {
            NSString * filename = @"somefile";
            // Video filenames are used to determine the video format... this is a workaround to create such a filename so the server can decode the video file
            if([key isEqualToString:@"video"] && [sender respondsToSelector:@selector(getVideoExtensionString)]){
                NSString * extension = [sender performSelector:@selector(getVideoExtensionString)];
                filename = [NSString stringWithFormat:@"somefile.%@", extension];
            }
            [self.multipartParams addObject:[[BVMultipartStreamParam alloc] initWithKey:key
                                                                                   data:value
                                                                               boundary:self.boundary
                                                                               filename:filename]];
        } else if([value isKindOfClass:[NSURL class]]) {
            NSString * filename = @"somefile";
            // Video filenames are used to determine the video format... this is a workaround to create such a filename so the server can decode the video file
            if([key isEqualToString:@"video"] && [sender respondsToSelector:@selector(getVideoExtensionString)]){
                NSString * extension = [sender performSelector:@selector(getVideoExtensionString)];
                filename = [NSString stringWithFormat:@"somefile.%@", extension];
            }
            [self.multipartParams addObject:[[BVMultipartStreamParam alloc] initWithKey:key
                                                                                   file:value
                                                                               boundary:self.boundary
                                                                               filename:filename]];
        }

    }
}

- (BVMultipartStreamParam *)getParamForCurrentBytesDelivered {
    uint byteDivider = 0;
    for (BVMultipartStreamParam * streamParam in self.multipartParams){
        uint newByteDivider = byteDivider + streamParam.length;
        if(self.bytesDelivered >= byteDivider && self.bytesDelivered < newByteDivider) {
            return streamParam;
        }
        byteDivider = newByteDivider;
    }
    return nil;
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)maxLength {
    
    _streamStatus = NSStreamStatusReading;
    BVMultipartStreamParam * currentParam = [self getParamForCurrentBytesDelivered];

    uint bytesSent = [currentParam read:buffer maxLength:maxLength];
    self.bytesDelivered += bytesSent;
    
    // Close the request
    if (self.bytesDelivered >= ([self getLengthOfParams]) && bytesSent < maxLength) {
        uint bytesRemaining = self.length - self.bytesDelivered;
        uint byteOffset = self.bytesDelivered - [self getLengthOfParams];
        uint bytesRead = MIN(bytesRemaining, maxLength - bytesSent);
        [self.requestFooter getBytes:buffer + bytesSent range:NSMakeRange(byteOffset, bytesRead)];
        bytesSent += bytesRead;
        self.bytesDelivered += bytesRead;
    }
    
    if (self.bytesDelivered >= self.length) { _streamStatus = NSStreamStatusAtEnd; }
    return bytesSent;
}

- (BOOL) hasBytesAvailable { return self.bytesDelivered < self.length; }
- (void) close { _streamStatus = NSStreamStatusClosed; }
- (void) open { _streamStatus = NSStreamStatusOpen; }

- (uint)getLengthOfParams {
    uint length = 0;
    for ( BVMultipartStreamParam * streamParam in self.multipartParams){
        length += streamParam.length;
    }
    return length;
}

- (uint) length {
    return [self getLengthOfParams] + self.requestFooter.length;
}

// Based on http://blog.blazingcloud.net/2012/08/14/uploads-got-you-down/
// Undocumented weirdness with NSInputStream subclasses
- (BOOL) setCFClientFlags:(CFOptionFlags)flgs callback:(CFReadStreamClientCallBack)cb context:(CFStreamClientContext*)ctx {
    return NO;
}

- (void) scheduleInCFRunLoop:(CFRunLoopRef)loop forMode:(CFStringRef)mode {}

- (void) unscheduleFromCFRunLoop:(CFRunLoopRef)loop forMode:(CFStringRef)mode {}

+ (BOOL) resolveInstanceMethod:(SEL) selector {
    NSString * name = NSStringFromSelector(selector);
    if ([name hasPrefix:@"_"]) {
        Method method = class_getInstanceMethod(self, NSSelectorFromString([name substringFromIndex:1]));
        if (method) {
            class_addMethod(self, selector, method_getImplementation(method), method_getTypeEncoding(method));
            return YES;
        }
    }
    return [super resolveInstanceMethod:selector];
}



@end




