//
//  BVBase.m
//  bazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

#import "BVBase.h"
#import "BVSBJson.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@interface BVBase()

@end

@implementation BVBase
@synthesize delegate = _delegate;
@synthesize settingsObject = _settingsObject;
@synthesize parameters = _parameters;
@synthesize rawURLRequest = _rawURLRequest;

- (id) init {
	self = [super init];
	if (self != nil) {
        // Initalization code here. Put in reasonable defaults.
        self.settingsObject = [BVSettings instance];
	}
	return self;
}

- (void)dealloc {
    // Set to nil because unsafe_unretained does not zero out pointers.
    self.settingsObject = nil;
    self.parameters = nil;
    self.delegate = nil;
    dataToReceive = nil;
}

#pragma mark Overrides
- (NSString*) contentType {
    return @"None";
}

- (NSString*) displayType {
    [NSException raise:@"displayType should be overridden by subclasses of BVBase" format:@""];
    return @"ERROR";
}

- (NSString*) fragmentForKey:(NSString*)key usingDictionary:(NSDictionary*)parametersDict {
    NSString *parameterValue = [parametersDict objectForKey:key];
    NSString *returnValue = [NSString stringWithFormat:@"&%@=%@", key, parameterValue];
    returnValue = [returnValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return returnValue;
}

- (NSString *)description {
    NSString *returnValue = [NSString stringWithFormat:@"BVDisplayType = %@" , self.displayType];
    
    return returnValue;
}

// Any time a subclass overrides this method, but sure to call [super generateURLRequestWithString:string]
// in the overridden method
- (NSMutableURLRequest*) generateURLRequestWithString:(NSString*)string{

    NSURL *urlString = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString];

    // Attach the SDK version header to every request.
    [request addValue:SDK_HEADER_VALUE forHTTPHeaderField:SDK_HEADER_NAME];
    
    return request;
}

#pragma mark Network Connections
- (void) initAsynchRequestWithString:(NSString*)string {
    NSMutableURLRequest *request = [self generateURLRequestWithString:string];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
        dataToReceive = [[NSMutableData alloc] init];
}

#pragma mark Methods
- (BVParameters*) parameters {
    // Lazy instationation...
    if (_parameters == nil) 
        _parameters = [[BVParameters alloc] init];
    return _parameters;
}

- (NSString*) parameterURL {
    id parameterValue; NSString *appendThisFragment;
    NSDictionary *parametersDict = self.parameters.dictionaryOfValues;
    NSString *returnValue = @"";
    for (NSString *key in parametersDict) {
        parameterValue = [parametersDict objectForKey:key];
        // If the parameter has a valid value, let's process it.
        if (![parameterValue isKindOfClass:[NSNull class]]) {
            appendThisFragment = [self fragmentForKey:key usingDictionary:parametersDict];
            if (appendThisFragment) 
                returnValue = [returnValue stringByAppendingString:appendThisFragment]; // Append the key and value
        }
    }
    
    return returnValue;
}

- (NSString*) buildURLString {
    NSString *buildString = [NSString stringWithFormat:@"http://%@/%@/", self.settingsObject.customerName, self.settingsObject.dataString];
    buildString = [buildString stringByAppendingFormat:@"%@.%@?", self.displayType, self.settingsObject.formatString];
    buildString = [buildString stringByAppendingFormat:@"apiversion=%@&passkey=%@", self.settingsObject.apiVersion, self.settingsObject.passKey];
    buildString = [buildString stringByAppendingString:self.parameterURL];
    
    return buildString;
}

- (void) startAsynchRequest {
    // Start building the REQUEST.
    NSString *URLToSend = [self buildURLString];
    
    NSLog(@"Request to be sent: %@", URLToSend);
    _rawURLRequest = URLToSend;
    [self initAsynchRequestWithString:URLToSend];
}

- (NSInteger) returnIntegerWithNSNumber:(NSNumber*)number {
    // Return number with NSNumber, 0 if otherwise.
    NSInteger returnValue = 0;
    if (number)
        if ([number isKindOfClass:[NSNumber class]]) {
            returnValue = [number intValue];
        }
    
    return returnValue;
}

#pragma mark NSURLConnection delegates
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataString = [[NSString alloc] initWithData:dataToReceive encoding:NSUTF8StringEncoding];
    
    // Parse JSON response into NSDictionary. Need to parse it down further into dependent objects.
    NSDictionary *respDict = [dataString JSONValue];
    BVResponse *newResponse = [[BVResponse alloc] init];
    
    // Parse the response.
    newResponse.hasErrors = [[respDict objectForKey:@"HasErrors"] boolValue];
    newResponse.errors = [respDict objectForKey:@"Errors"];
    if (!newResponse.hasErrors) {
        newResponse.includes = [respDict objectForKey:@"Includes"];
        newResponse.results = [respDict objectForKey:@"Results"];
        newResponse.locale = [respDict objectForKey:@"Locale"];
                
        newResponse.limit = [self returnIntegerWithNSNumber:[respDict objectForKey:@"Limit"]];
        newResponse.totalResults = [self returnIntegerWithNSNumber:[respDict objectForKey:@"TotalResults"]];
        newResponse.offset = [self returnIntegerWithNSNumber:[respDict objectForKey:@"Offset"]];
        
        newResponse.data = [respDict objectForKey:@"Data"];
        newResponse.form = [respDict objectForKey:@"Form"];
        newResponse.formErrors = [respDict objectForKey:@"FormErrors"];
        newResponse.typicalHoursToPost = [self returnIntegerWithNSNumber:[respDict objectForKey:@"TypicalHoursToPost"]];
        newResponse.contentData = [respDict objectForKey:self.contentType];
        newResponse.contentType = self.contentType;
        newResponse.field = [respDict objectForKey:@"Field"];
        newResponse.group = [respDict objectForKey:@"Group"];
        newResponse.subelements = [respDict objectForKey:@"Subelements"];
    }
    
    newResponse.rawResponse = respDict;
    newResponse.rawURLRequest = self.rawURLRequest;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didReceiveResponse:forRequest:)])
        [self.delegate didReceiveResponse:newResponse forRequest:self];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:forRequest:)])
    {
        [self.delegate didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite forRequest:self];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [dataToReceive setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [dataToReceive appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailToReceiveResponse:forRequest:)])
        [self.delegate didFailToReceiveResponse:error forRequest:self];
}

@end