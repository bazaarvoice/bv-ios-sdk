//
//  BVAuthenticatedUser.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

/// user information can be included in the userAuthString - sent with:
/// [[BVSDKManager sharedManager] setUserWithAuthString:myAuthString];

#define BVUSER_ID @"userid"
#define BVUSER_AGE @"age";
#define BVUSER_GENDER @"gender";
#define BVUSER_EMAIL @"email";
#define BVUSER_FACEBOOKID = @"facebookId";
#define BVUSER_TWITTERID = @"twitterId";

#import <Foundation/Foundation.h>

/**
    This class provides Bazaarvoice to register the current device with an
   existing user profile. In order to use this profile, you must provide your
   client application a valid authentication string, calculated server-side. For
   more information on calculating the Authorization string, please refer to the
   [Bazaarvoice
   documentation](http://knowledge.bazaarvoice.com/wp-content/conversations/en_US/KB/Default.htm#Authentication/Site_authentication/Tech_integration_site_auth.htm%23Generate)
   . The authentication recipe is valid for any customer of the Conversations,
   Ads, or Recommendations APIs.
 */
@interface BVAuthenticatedUser : NSObject

/// The server-side calulated Authentication string
@property NSString *userAuthString;

/**
    Update the user profile for the client device given a valid Authentication
   string.

    @param force   Force the profile to be updated, regardless last time of
   update.
    @param passKey The Authentication string
    @param isStage pass in YES if using staging server, NO for production.
 */
- (void)updateProfile:(BOOL)force
           withAPIKey:(NSString *)passKey
            isStaging:(BOOL)isStage;

@end
