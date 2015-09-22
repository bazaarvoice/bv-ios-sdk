//
//  BVNetwork.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BVNetwork.h"
#import "BVSettings.h"
#import "BVMediaPost.h"
#import "BVAnalytics.h"

@interface BVNetwork ()
@property (strong) NSMutableDictionary *params;
@property (strong) NSMutableData *receivedData;
@property (strong) NSDictionary *responseHeaders;
@property (strong) NSHTTPURLResponse *responseObject;
@property NSInteger responseStatusCode;
@end


@implementation BVNetwork

- (id)initWithSender:(id)sender {
    self = [super init];
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        self.sender = sender;
    }
    return self;
}

- (void)setUrlParameterWithName:(NSString *)name value:(id)value {
    if(value == nil){
        value = @"";
    }
    [self.params setObject:value forKey:name];
}

- (void)setUrlListParameterWithName:(NSString *)name value:(NSString *)value {
    if(value == nil){
        value = @"";
    }
    NSString *currentValue = [self.params objectForKey:name];
    if(currentValue){
        [self.params setObject:[NSString stringWithFormat:@"%@,%@", currentValue, value] forKey:name];
    } else {
        [self.params setObject:value forKey:name];
    }
}

- (void)addUrlParameterWithName:(NSString *)name value:(NSString *)value {
    if(value == nil){
        value = @"";
    }
    NSMutableArray *currentValue = [self.params objectForKey:name];
    if(currentValue){
        [currentValue addObject:value];
    } else {
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects:value, nil];
        [self.params setObject:newArray forKey:name];
    }
}

- (void)addNthUrlParameterWithName:(NSString *)name value:(NSString *)value {
    if(value == nil){
        value = @"";
    }
    int index = 1;
    while(true){
        NSString *nthKey = [NSString  stringWithFormat:@"%@_%d", name, index];
        NSMutableArray *currentValue = [self.params objectForKey:nthKey];
        if(currentValue == nil){
            [self setUrlParameterWithName:nthKey value:value];
            break;
        } else {
            index++;
        }
    }
}

static NSString *urlEncode(id object) {
    
    NSString *string = [NSString stringWithFormat: @"%@", object];
    
    NSMutableCharacterSet *chars = NSCharacterSet.URLQueryAllowedCharacterSet.mutableCopy;
    [chars removeCharactersInRange:NSMakeRange('&', 1)]; // %26
    return [string stringByAddingPercentEncodingWithAllowedCharacters:chars];
}

-(NSString*) getParamsString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self.params) {
        id value = [self.params objectForKey: key];
        if([value isKindOfClass:[NSArray class]]) {
            for(NSString * valueString in value){
                NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(valueString)];
                [parts addObject: part];
            }
        } else if([value isKindOfClass:[NSString class]]) {
            NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
            [parts addObject: part];
        }
    }
    return [parts componentsJoinedByString: @"&"];
}

- (void)sendGetWithEndpoint:(NSString *)endpoint {
    [self sendGetWithEndpoint:endpoint withUrlString:nil];
}

- (void)sendGetWithEndpoint:(NSString *)endpoint withUrlString:(NSString *)urlString {
    BVSettings *settings = [BVSettings instance];
    if (urlString == nil) {
        urlString = [NSString stringWithFormat:@"http://%@api.bazaarvoice.com/data/%@?%@",
                     settings.staging ? @"stg." : @"",
                     endpoint,
                     [self getParamsString]];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@?%@",
                     urlString,
                     [self getParamsString]];
    }

    // This network object may be deallocated before the sender is deallocated, but we still want
    // the client to be able to know the url of this request.  Therefore, it is stored by the sender
    // after the request is sent.
    if([self.sender respondsToSelector:@selector(setRequestURL:)]) {
        [self.sender performSelector:@selector(setRequestURL:) withObject:urlString];

    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:urlString]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:settings.timeout];
    [request setHTTPMethod:@"GET"];
    // Attach the SDK version header to every request.
    [request addValue:SDK_HEADER_VALUE forHTTPHeaderField:SDK_HEADER_NAME];
    
    
    
    NSURLSession *session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                             delegate:self
                             delegateQueue:nil];
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request];
    [sessionTask resume];
    if (sessionTask) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
    }
}


- (void)sendPostWithEndpoint:(NSString *)endpoint multipart:(BOOL)mutipart {
    if(self.delegate == nil){
        NSException *exception = [NSException exceptionWithName: @"DelegateNotSetException"
                                                         reason: @"A delegate must be set before a request is sent."
                                                       userInfo: nil];
        @throw exception;
    }
    BVSettings *settings = [BVSettings instance];
    NSString *urlString = [NSString stringWithFormat:@"http://%@api.bazaarvoice.com/data/%@",
                           settings.staging ? @"stg." : @"",
                           endpoint];
    
    // This network object may be deallocated before the sender is deallocated, but we still want
    // the client to be able to know the url of this request.  Therefore, it is stored by the sender
    // after the request is sent.
    if([self.sender respondsToSelector:@selector(setRequestURL:)]) {
        [self.sender performSelector:@selector(setRequestURL:) withObject:urlString];
        
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:urlString]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:settings.timeout];
    [request setHTTPMethod:@"POST"];
    
    if(mutipart) {
        [self setMultipartData:request];
    } else {
        [self setPostData:request];
    }
    
    // Attach the SDK version header to every request.
    [request addValue:SDK_HEADER_VALUE forHTTPHeaderField:SDK_HEADER_NAME];
    
    NSURLSession *session = [NSURLSession
                             sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                             delegate:self
                             delegateQueue:nil];
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request];
    [sessionTask resume];
    if (sessionTask) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
    }
}

- (void)sendPostWithEndpoint:(NSString *)endpoint {
    [self sendPostWithEndpoint:endpoint multipart:NO];
}

- (void)sendMultipartPostWithEndpoint:(NSString *)endpoint {
    [self sendPostWithEndpoint:endpoint multipart:YES];
}

- (void) setPostData:(NSMutableURLRequest *)request {
    NSData *postData = [[self getParamsString] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
}

// We need to generate a multi-part form POST
- (void) setMultipartData:(NSMutableURLRequest *)request {
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"----------------------------f3a1ba9c57bd";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    for (id key in self.params) {
        id value = [self.params objectForKey: key];
        if([value isKindOfClass:[NSArray class]]) {
            for(NSString* valueString in value){
                [self appendKey:key value:valueString toMultipartData:body withBoundary:boundary];
            }
        } else if([value isKindOfClass:[NSString class]]) {
            [self appendKey:key value:value toMultipartData:body withBoundary:boundary];
        } else if([value isKindOfClass:[UIImage class]]) {
            UIImage * image = value;
            [self appendKey:key data:UIImageJPEGRepresentation(image, 1.0) toMultipartData:body withBoundary:boundary];
        } else if([value isKindOfClass:[NSData class]]) {
            [self appendKey:key data:value toMultipartData:body withBoundary:boundary];
        }
    }
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    // set request body
    [request setHTTPBody:body];
    
    //NSString *printString = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
    //NSLog(@"Body: %@", printString);
}

- (void)appendKey:(NSString *)key data:(NSData *)data toMultipartData:(NSMutableData *)body withBoundary:(NSString *)boundary {
    NSString *filename;
    // Video filenames are used to determine the video format... this is a workaround to create such a filename so the server can decode the video file
    if([key isEqualToString:@"video"] && [self.sender respondsToSelector:@selector(getVideoExtensionString)]){
        NSString * extension = [self.sender performSelector:@selector(getVideoExtensionString)];
        filename = [NSString stringWithFormat:@"somefile.%@", extension];
    } else {
        filename = @"somefile";
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendKey:(NSString *)key value:(NSString *)value toMultipartData:(NSMutableData *)body withBoundary:(NSString *)boundary {
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}



#pragma mark NSURLSession delegates

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:forRequest:)])
    {
        [self.delegate didSendBodyData:bytesSent totalBytesWritten:totalBytesSent totalBytesExpectedToWrite:totalBytesExpectedToSend forRequest:self.sender];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    self.responseObject = (NSHTTPURLResponse*) response;
    self.responseHeaders = [self.responseObject allHeaderFields];
    self.responseStatusCode = [self.responseObject statusCode];
    [self.receivedData setLength:0];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailToReceiveResponse:forRequest:)]){
            [self.delegate didFailToReceiveResponse:error forRequest:self.sender];
        }
    } else {
        NSError *error = nil;
        NSDictionary *response;
        if ([[self.responseHeaders objectForKey:@"Content-Type"] isEqualToString:@"application/json;charset=utf-8"]) {
            response = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:&error];
        }
        else if (self.responseStatusCode == 200) {
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            [result setObject:self.responseObject.URL forKey:@"URL"];
            [result setObject:@(self.responseStatusCode) forKey:@"statusCode"];
            [result setObject:self.responseHeaders forKey:@"headers"];
            [result setObject:@(NO) forKey:@"HasErrors"];
            response = result;
        }
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didReceiveResponse:forRequest:)]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[BVAnalytics instance] queueAnalyticsEventForResponse:response forRequest:self.sender];
            });
            
            [self.delegate didReceiveResponse:response forRequest:self.sender];
        }
    }
}

@end
