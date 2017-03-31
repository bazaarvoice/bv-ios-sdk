//
//  ConversationsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsRequest.h"
#import "BVSDKManager.h"
#import "BVAnalyticsManager.h"
#import "BVDiagnosticHelpers.h"
#import "BVConversationsErrorResponse.h"
#import "BVStoreReviewsResponse.h"
#import "BVSDKConfiguration.h"

@interface BVConversationsRequest()
@property (strong, nonatomic) NSMutableArray<BVStringKeyValuePair*>* additionalParams;
@end

@implementation BVConversationsRequest


-(NSMutableArray<BVStringKeyValuePair*>* _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [NSMutableArray array];
    
    [params addObject:[BVStringKeyValuePair pairWithKey:@"apiversion" value:@"5.4"]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"passkey" value:[self getPassKey]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_appId" value:[NSBundle mainBundle].bundleIdentifier]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_appVersion" value:[BVDiagnosticHelpers releaseVersionNumber]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_buildNumber" value:[BVDiagnosticHelpers buildVersionNumber]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_bvIosSdkVersion" value:BV_SDK_VERSION]];
    
    if (_additionalParams){
        [params addObjectsFromArray:_additionalParams];
    }

    return params;
    
}

-(nonnull instancetype)addAdditionalField:(nonnull NSString*)fieldName value:(nonnull NSString*)value{
    
    if (fieldName && value){
        
        if (!self.additionalParams){
            self.additionalParams = [NSMutableArray array];
        }
        
        [_additionalParams addObject:[BVStringKeyValuePair pairWithKey:fieldName value:value]];
        
    } else {
        NSAssert(NO, @"illegal use of non-null parameters");
    }
    
    return self;
}



-(NSString* _Nonnull)endpoint {
    return @"must be overriden";
}

+(NSString* _Nonnull)commonEndpoint {
    return [BVSDKManager sharedManager].configuration.staging ? @"https://stg.api.bazaarvoice.com/data/" : @"https://api.bazaarvoice.com/data/";
}

-(NSArray<NSURLQueryItem*>* _Nonnull)getQueryItems:(NSArray<BVStringKeyValuePair*>*)params {
    
    NSMutableArray<NSURLQueryItem*>* queryItems = [NSMutableArray array];
    
    for(BVStringKeyValuePair* param in params) {
        if(param.value != nil){
            NSURLQueryItem* queryItem = [[NSURLQueryItem alloc] initWithName:param.key value:param.value];
            [queryItems addObject:queryItem];
        }
    }
    
    return queryItems;
    
}

- (void)loadContent:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(NSDictionary* _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError*>* _Nonnull errors))failure {
 
    NSString* url = [NSString stringWithFormat:@"%@%@", [BVConversationsRequest commonEndpoint], [request endpoint]];
    NSURLComponents* urlComponents = [NSURLComponents componentsWithString:url];
    NSArray<BVStringKeyValuePair*>* parameters = [request createParams];
    urlComponents.queryItems = [self getQueryItems:parameters];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:urlComponents.URL];
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", urlRequest.URL]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        [self processData:data response:response error:error completion:completion failure:failure];
        
    }];
    
    // start the request
    [task resume];

}

-(void)processData:(NSData* _Nullable)data response:(NSURLResponse* _Nullable)response error:(NSError* _Nullable)error completion:(void (^ _Nonnull)(NSDictionary* _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError*>* _Nonnull errors))failure {

    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger statusCode = [httpResponse statusCode];
    
    if(statusCode == 200) {
        @try {
            NSError* err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (json != nil){

                BVConversationsErrorResponse* errorResponse = [[BVConversationsErrorResponse alloc] initWithApiResponse:json];
                
                [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json, (long)statusCode]];
                
                if (errorResponse != nil) {
                    [self sendErrors:[errorResponse toNSErrors] failureCallback:failure];
                }
                else {
                    // invoke success callback on main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(json);
                    });
                }
            }
            else if (err != nil) {
                [self sendError:err failureCallback:failure];
            }
            else {
                NSError* parsingError = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_PARSING_FAILED userInfo:@{NSLocalizedDescriptionKey:@"An unknown parsing error occurred."}];
                [self sendError:parsingError failureCallback:failure];
            }
            
        }
        @catch (NSException *exception) {
            NSError* err = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_UNKNOWN userInfo:@{NSLocalizedDescriptionKey:@"An unknown parsing error occurred."}];
            [self sendError:err failureCallback:failure];
        }
    }
    else {
        NSString* message = [NSString stringWithFormat:@"HTTP response status code: %li with error: %@", (long)statusCode, error.localizedDescription];
        NSError* enhancedError = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_NETWORK_FAILED userInfo:@{NSLocalizedDescriptionKey: message}];
        [self sendError:enhancedError failureCallback:failure];
    }
}


- (NSError * _Nonnull)limitError:(NSInteger)limit {
    
    NSString* message = [NSString stringWithFormat:@"Invalid `limit` value: Parameter 'limit' has invalid value: %li - must be between 1 and 100.", (long)limit];
    return [NSError errorWithDomain:BVErrDomain code:BV_ERROR_INVALID_LIMIT userInfo:@{NSLocalizedDescriptionKey: message}];
    
}

- (NSError * _Nonnull)tooManyProductsError:(NSArray<NSString *> * _Nonnull)productIds {
    
    NSString* message = [NSString stringWithFormat:@"Too many productIds requested: %lu. Must be between 1 and 100.", (unsigned long)[productIds count]];
    return [NSError errorWithDomain:BVErrDomain code:BV_ERROR_TOO_MANY_PRODUCTS userInfo:@{NSLocalizedDescriptionKey: message}];
    
}

-(void)sendError:(nonnull NSError*)error failureCallback:(ConversationsFailureHandler) failure {
    [self sendErrors:@[error] failureCallback:failure];
}

-(void)sendErrors:(nonnull NSArray<NSError*>*)errors failureCallback:(ConversationsFailureHandler) failure {
    for (NSError* error in errors) {
        [[BVLogger sharedLogger] printError:error];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(errors);
    });
}

- (NSString * _Nonnull)getPassKey{
   return [BVSDKManager sharedManager].configuration.apiKeyConversations;
}


@end
