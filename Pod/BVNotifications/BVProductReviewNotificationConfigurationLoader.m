//
//  BVProductReviewNotificationConfigurationLoader.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVProductReviewNotificationConfigurationLoader.h"
#import "BVNotificationConfiguration.h"
#import "BVSDKManager.h"
#import "BVSDKConfiguration.h"

@implementation BVProductReviewNotificationConfigurationLoader

+(void)load{
    [self sharedManager];
}

+(id)sharedManager {
    static BVProductReviewNotificationConfigurationLoader *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    
    return shared;
}

- (id)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePINAPIKey:)
                                                     name:PIN_API_KEY_SET_NOTIFICATION
                                                   object:nil];
        
    }
    
    return self;
}


- (void) receivePINAPIKey:(NSNotification *) notification
{    
    // [notification name] should always be PIN_API_KEY_SET_NOTIFICATION
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:PIN_API_KEY_SET_NOTIFICATION]){
        
        [[BVLogger sharedLogger] verbose:@"Recieved notifcation for PIN configuration"];
        
        [self loadPINConfiguration:^(BVProductReviewNotificationProperties * _Nonnull response) {
            // success
        } failure:^(NSError * _Nonnull error) {
            // failed
        }];
        
    }
}


-(void)loadPINConfiguration:(void (^ _Nonnull)(BVProductReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/incubator-mobile-apps/sdk/%@/ios/%@/pin/pinConfig.json", NOTIFICATION_CONFIG_ROOT, S3_API_VERSION, [[[BVSDKManager sharedManager] configuration] clientId]]];
    [BVNotificationConfiguration loadPINConfiguration:url completion:^(BVProductReviewNotificationProperties * _Nonnull response) {
        [[BVLogger sharedLogger] verbose:@"Successfully loaded BVProductReviewNotificationProperties"];
        _bvProductReviewNotificationProperties = response;
        completion(response);
        
    } failure:^(NSError * _Nonnull error) {
        [[BVLogger sharedLogger] error:@"ERROR: Failed to load BVProductReviewNotificationProperties"];
        failure(error);
    }];
    
}

@end
