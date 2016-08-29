//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//


#import <SDForms/SDForms.h>
#import "LocationPickerView.h"
#import "JPSThumbnail.h"

#if __has_include("BVUserAuthStringGenerator.h")
    // For internal testing only
    #import "BVUserAuthStringGenerator.h"
    #define SITE_AUTH 1
#else

    #define SITE_AUTH 0
    // dummy declaration
    // For a live Site Authentication, you migth have your own server-side call that provides a user info dictionary
    // and returns a valid BV User Authentication String (UAS)
    @interface BVUserAuthStringGenerator : NSObject
    + (void)generateUAS:(NSDictionary *)userInfo withCompletion:(void(^)(NSString *uas, NSError *error))completionHandler;
    @end

#endif
