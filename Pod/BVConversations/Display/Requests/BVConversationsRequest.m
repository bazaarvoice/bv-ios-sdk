//
//  ConversationsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsRequest.h"
#import "BVSDKManager.h"
#import "NSBundle+DiagnosticInformation.h"
#import "BVConversationsErrorResponse.h"
#import "BVConversationsAnalyticsUtil.h"

@implementation BVConversationsRequest

-(NSMutableArray<BVStringKeyValuePair*>* _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [NSMutableArray array];
    
    [params addObject:[BVStringKeyValuePair pairWithKey:@"apiversion" value:@"5.4"]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"passkey" value:[BVSDKManager sharedManager].apiKeyConversations]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_appId" value:[NSBundle mainBundle].bundleIdentifier]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_appVersion" value:[NSBundle_DiagnosticInformation releaseVersionNumber]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_buildNumber" value:[NSBundle_DiagnosticInformation buildVersionNumber]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"_bvIosSdkVersion" value:BV_SDK_VERSION]];
    
    return params;
    
}

-(NSString* _Nonnull)endpoint {
    return @"must be overriden";
}

+(NSString* _Nonnull)commonEndpoint {
    return [BVSDKManager sharedManager].staging ? @"https://stg.api.bazaarvoice.com/data/" : @"https://api.bazaarvoice.com/data/";
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

- (void)loadReviews:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVReviewsResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure {

    [self loadContent:request completion:^(NSDictionary * _Nonnull response) {
        BVReviewsResponse* reviewResponse = [[BVReviewsResponse alloc] initWithApiResponse:response];
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(reviewResponse);
        });
        [self sendReviewsAnalytics:reviewResponse];
    } failure:failure];
    
}


- (void)loadProducts:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVProductsResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure {
    
    [self loadContent:request completion:^(NSDictionary * _Nonnull response) {
        BVProductsResponse* productsResponse = [[BVProductsResponse alloc] initWithApiResponse:response];
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(productsResponse);
        });
        [self sendProductsAnalytics:productsResponse];
    } failure:failure];
    
}

- (void)loadQuestions:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVQuestionsAndAnswersResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure {
    
    [self loadContent:request completion:^(NSDictionary * _Nonnull response) {
        BVQuestionsAndAnswersResponse* questionsAndAnswersResponse = [[BVQuestionsAndAnswersResponse alloc] initWithApiResponse:response];
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(questionsAndAnswersResponse);
        });
        [self sendQuestionsAnalytics:questionsAndAnswersResponse];
    } failure:failure];
    
}

- (void)loadBulkRatings:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVBulkRatingsResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure {
    
    [self loadContent:request completion:^(NSDictionary * _Nonnull response) {

        BVBulkRatingsResponse* bulkRatingsResponse = [[BVBulkRatingsResponse alloc] initWithApiResponse:response];
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(bulkRatingsResponse);
        });

    } failure:failure];
    
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
                
                [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%d)", json, statusCode]];
                
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
        NSString* message = [NSString stringWithFormat:@"HTTP response status code: %li with error: %@", statusCode, error.localizedDescription];
        NSError* enhancedError = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_NETWORK_FAILED userInfo:@{NSLocalizedDescriptionKey: message}];
        [self sendError:enhancedError failureCallback:failure];
    }
}


- (NSError * _Nonnull)limitError:(NSInteger)limit {
    
    NSString* message = [NSString stringWithFormat:@"Invalid `limit` value: Parameter 'limit' has invalid value: %li - must be between 1 and 20.", limit];
    return [NSError errorWithDomain:BVErrDomain code:BV_ERROR_INVALID_LIMIT userInfo:@{NSLocalizedDescriptionKey: message}];
    
}

- (NSError * _Nonnull)tooManyProductsError:(NSArray<NSString *> * _Nonnull)productIds {
    
    NSString* message = [NSString stringWithFormat:@"Too many productIds requested: %li. Must be between 1 and 50.", [productIds count]];
    return [NSError errorWithDomain:BVErrDomain code:BV_ERROR_TOO_MANY_PRODUCTS userInfo:@{NSLocalizedDescriptionKey: message}];
    
}

-(void)sendError:(nonnull NSError*)error failureCallback:(ConversationsFailureHandler) failure {
    [[BVLogger sharedLogger] printError:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(@[error]);
    });
}

-(void)sendErrors:(nonnull NSArray<NSError*>*)errors failureCallback:(ConversationsFailureHandler) failure {
    for (NSError* error in errors) {
        [[BVLogger sharedLogger] printError:error];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(errors);
    });
}

- (void)sendReviewsAnalytics:(BVReviewsResponse*)reviewsResponse {
    
    for (BVReview* review in reviewsResponse.results) {
        NSDictionary* event = [BVConversationsAnalyticsUtil reviewAnalyticsEvents:review];
        [[BVAnalyticsManager sharedManager] queueEvent:event];
    }
    // send pageview for product
    BVReview* review = reviewsResponse.results.firstObject;
    if (review != nil) {
        NSNumber* count = @([reviewsResponse.results count]);
        [BVConversationsAnalyticsUtil queueAnalyticsEventForProductPageView:review.productId numReviews:count numQuestions:nil];
    }

}

- (void)sendQuestionsAnalytics:(BVQuestionsAndAnswersResponse*)questionsResponse {
    
    for (BVQuestion* question in questionsResponse.results) {
        NSArray<NSDictionary*>* events = [BVConversationsAnalyticsUtil questionAnalyticsEvents:question];
        for(NSDictionary* event in events) {
            [[BVAnalyticsManager sharedManager] queueEvent:event];
        }
    }
    // send pageview for product
    BVQuestion* question = questionsResponse.results.firstObject;
    if (question != nil) {
        NSNumber* count = @([questionsResponse.results count]);
        [BVConversationsAnalyticsUtil queueAnalyticsEventForProductPageView:question.productId numReviews:nil numQuestions:count];
    }
    
}

- (void)sendProductsAnalytics:(BVProductsResponse*)productsResponse {
    
    BVProduct* product = productsResponse.result;
    if (product) {
        // send impressions for included content
        for(NSDictionary* event in [BVConversationsAnalyticsUtil productAnalyticsEvents:product]) {
            [[BVAnalyticsManager sharedManager] queueEvent:event];
        }
        // send pageview for product
        [BVConversationsAnalyticsUtil queueAnalyticsEventForProductPageView:product];
    }
    
}



@end
