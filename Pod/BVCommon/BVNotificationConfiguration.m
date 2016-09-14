//
//  BVNotificationConfiguration.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationConfiguration.h"
#import "BVCore.h"

@implementation BVNotificationConfiguration

+ (void)loadConfiguration:(NSURL* _Nonnull)url completion:(void (^ _Nonnull)(BVStoreReviewNotificationProperties* _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull errors))failure {
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", url]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if (!error && httpResponse.statusCode <300 ){
            
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
            if (jsonDict){
                BVStoreReviewNotificationProperties *props = [[BVStoreReviewNotificationProperties alloc] initWithDictionary:jsonDict];
                completion(props);
            }
            
        } else {
            [[BVLogger sharedLogger] error:[NSString stringWithFormat:@"Failed to fetch notification configuration: %@", error.localizedDescription]];
            failure(error);
        }
        
    }];
    
    // start the request
    [task resume];

}


@end
