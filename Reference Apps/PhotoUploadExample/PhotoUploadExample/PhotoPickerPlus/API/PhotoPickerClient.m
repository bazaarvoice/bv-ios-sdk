//
//  PhotoPickerClient.m
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/7/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "PhotoPickerClient.h"
#import <AFJSONRequestOperation.h>
#import "GCAccountAlbum.h"
#import "GCAccountAssets.h"

#import <Chute-SDK/GCResponse.h>
#import <Chute-SDK/GCResponseStatus.h>
#import <Chute-SDK/GCPagination.h>
#import <DCKeyValueObjectMapping.h>

static NSString * const kBaseURLString = @"http://accounts.getchute.com/v2/";
//static NSString * const kBaseURLString = @"https://dl.dropboxusercontent.com/u/23635319/ChuteAPI/files.json";
static dispatch_queue_t serialQueue;

static NSString * const kResponse = @"response";
static NSString * const kData = @"data";
static NSString * const kPagination = @"pagination";

static NSString *const kFolders = @"folders";
static NSString *const kFiles = @"files";

@implementation PhotoPickerClient

+ (PhotoPickerClient *)sharedClient
{
    static PhotoPickerClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.getchute.photopickerclient.serialqueue", NULL);
        _sharedClient = [[PhotoPickerClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    });
    
    [_sharedClient setParameterEncoding:AFJSONParameterEncoding];
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    return self;
}
#pragma mark - Base Method for the Services
// request, success, failure

- (void)request:(NSMutableURLRequest *)request success:(void(^)(GCResponseStatus *, NSArray *, NSArray *))success failure:(void(^)(NSError *))failure
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [self parseJSON:JSON success:success];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failure: %@", JSON);
        
        failure(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)parseJSON:(id)JSON success:(void(^)(GCResponseStatus *, NSArray *, NSArray *))success
{
    DCKeyValueObjectMapping *responseParser = [DCKeyValueObjectMapping mapperForClass:[GCResponseStatus class]];
    DCKeyValueObjectMapping *foldersParser = [DCKeyValueObjectMapping mapperForClass:[GCAccountAlbum class]];
    DCKeyValueObjectMapping *filesParser = [DCKeyValueObjectMapping mapperForClass:[GCAccountAssets class]];
    
    GCResponseStatus *responseStatus = [responseParser parseDictionary:[JSON objectForKey:kResponse]];
    NSDictionary *data = [JSON objectForKey:kData];
    NSArray *folders = [foldersParser parseArray:[data objectForKey:kFolders]];
    NSArray *files = [filesParser parseArray:[data objectForKey:kFiles]];
    
    if([folders count] == 0)
        folders = nil;
    if([files count] == 0)
        files = nil;
    
    success(responseStatus, folders, files);
}

@end
