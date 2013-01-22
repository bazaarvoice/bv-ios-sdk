//
//  GCConstants.h
//
//  Copyright 2011 Chute Corporation. All rights reserved.
//

//////////////////////////////////////////////////////////
//                                                      //
//                   VERSION 1.0.8                      //
//                                                      //
//////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Set which service is to be used
// 0 - Facebook
// 1 - Evernote
// 2 - Chute
// 3 - Twitter
// 4 - Foursquare

#define kSERVICE 0

////////////////////////////////////////////////////////////////////////////////////////////////////////

#define API_URL @"https://api.getchute.com/v1/"
#define SERVER_URL @"https://getchute.com"

////////////////////////////////////////////////////////////////////////////////////////////////////////

//#define kUDID               [[UIDevice currentDevice] uniqueIdentifier]
#define kDEVICE_NAME        [[UIDevice currentDevice] name]
#define kDEVICE_OS          [[UIDevice currentDevice] systemName]
#define kDEVICE_VERSION     [[UIDevice currentDevice] systemVersion]

//replace the following setting with your own client info
#define kOAuthCallbackURL               @"http://getchute.com/oauth/callback"
#define kOAuthCallbackRelativeURL       @"/oauth/callback"
#define kOAuthAppID                     @"50ca0101018d165886000108"
#define kOAuthAppSecret                 @"dbe68cdec5fb45c1e32296ee990a299255804dbd130155b3acbf802d203cf0b4"

#define kOAuthPermissions               @"all_resources manage_resources profile resources"

#define kOAuthTokenURL                  @"https://getchute.com/oauth/access_token"