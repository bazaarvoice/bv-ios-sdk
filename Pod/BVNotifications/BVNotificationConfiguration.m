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

+ (void)loadGeofenceConfiguration:(NSURL * _Nonnull)url completion:(void (^ _Nonnull)(BVStoreReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull errors))failure {
    
    [self loadConfiguration:url completion:^(NSDictionary *response, NSError* error) {
        
        if (response == nil && error == nil){
            NSString *errorMessage = @"No config found for geofence notifications. Will not post notification.";
            [[BVLogger sharedLogger] error:errorMessage];
            [NSError errorWithDomain:BVErrDomain code:-1 userInfo:@{@"message" : errorMessage}];
            return failure(error);
        }
        
        if (!error) {
            BVStoreReviewNotificationProperties *props = [[BVStoreReviewNotificationProperties alloc] initWithDictionary:response];
            completion(props);

        }else {
            [[BVLogger sharedLogger] error:[NSString stringWithFormat:@"Failed to fetch store notification configuration: %@", error.localizedDescription]];
            failure(error);
        }
    }];
}

+ (void)loadPINConfiguration:(NSURL * _Nonnull)url completion:(void (^ _Nonnull)(BVProductReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull errors))failure {
    [self loadConfiguration:url completion:^(NSDictionary *response, NSError* error) {
        
        if (response == nil && error == nil){
            NSString *errorMessage = @"No notification config found for PIN. Will not post notifications.";
            [[BVLogger sharedLogger] error:errorMessage];
            [NSError errorWithDomain:BVErrDomain code:-1 userInfo:@{@"message" : errorMessage}];
            return failure(error);
        }
        
        if (!error) {
            BVProductReviewNotificationProperties *props = [[BVProductReviewNotificationProperties alloc] initWithDictionary:response];
            completion(props);
        }else {
            [[BVLogger sharedLogger] error:[NSString stringWithFormat:@"Failed to fetch store notification configuration: %@", error.localizedDescription]];
            failure(error);
        }
    }];
}

+ (void)loadConfiguration:(NSURL * _Nonnull)url completion:(void (^ _Nonnull)(NSDictionary * _Nullable response, NSError *error))completion {
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"GET: %@", url]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if (!error && httpResponse.statusCode <300 ){
            
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
            if (jsonDict){
                completion(jsonDict, nil);
            }
            
        } else {
            completion(nil, error);
        }
        
    }];
    
    // start the request
    [task resume];
    
}


@end
