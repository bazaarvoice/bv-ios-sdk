//
//  GCAccount.m
//
//  Created by Achal Aggarwal on 30/08/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCAccount.h"
#import "GCRequest.h"
#import "GCJson.h"
#import "GCConstants.h"
#import "ASIHTTPRequest.h"
#import "NSDictionary+QueryString.h"
#import "GCAsset.h"
#import "GCParcel.h"
#import "GCChute.h"

NSString * const GCAccountStatusChanged = @"GCAccountStatusChanged";
static GCAccount *sharedAccountManager = nil;

@implementation GCAccount

@synthesize accountStatus;
@synthesize accessToken;
@synthesize assetsArray;
@synthesize heartedAssets;
@synthesize assetsLibrary;

// Public: Retrives an array of dictionaries for each account from Chute service
// and loads the array into accounts object
//
// No return value.
- (void) loadAccounts {
    if(![[GCAccount sharedManager] accessToken])
        return;
    NSString *_path = [[NSString alloc] initWithFormat:@"%@accounts", API_URL];
    GCRequest *gcRequest = [[GCRequest alloc] init];
    
    GCResponse *response = [[gcRequest getRequestWithPath:_path] retain];
    
    if ([response isSuccessful]) {
        
        NSMutableArray *_data = [[NSMutableArray alloc] init];
        
        for (NSDictionary *_dic in [response data]) {
            NSMutableDictionary *_obj = [[NSMutableDictionary alloc] init];
            
            if([_dic objectForKey:@"access_key"] && ![[NSString stringWithFormat:@"%@",[_dic objectForKey:@"access_key"]] isEqualToString:@"<null>"])
                [_obj setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"access_key"]] forKey:@"access_key"];
            if([_dic objectForKey:@"type"] && ![[NSString stringWithFormat:@"%@",[_dic objectForKey:@"type"]] isEqualToString:@"<null>"])
                [_obj setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"type"]] forKey:@"type"];
            if([_dic objectForKey:@"uid"] && ![[NSString stringWithFormat:@"%@",[_dic objectForKey:@"uid"]] isEqualToString:@"<null>"])
                [_obj setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"uid"]] forKey:@"uid"];
            if([_dic objectForKey:@"id"] && ![[NSString stringWithFormat:@"%@",[_dic objectForKey:@"id"]] isEqualToString:@"<null>"])
                [_obj setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"id"]] forKey:@"accountID"];
            if([_dic objectForKey:@"name"] && ![[NSString stringWithFormat:@"%@",[_dic objectForKey:@"name"]] isEqualToString:@"<null>"])
                [_obj setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"name"]] forKey:@"name"];
            if([_dic objectForKey:@"notifications_enabled"] && ![[NSString stringWithFormat:@"%@",[_dic objectForKey:@"notifications_enabled"]] isEqualToString:@"<null>"])
                [_obj setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"notifications_enabled"]] forKey:@"notifications_enabled"];
            if([_dic objectForKey:@"status"] && ![[NSString stringWithFormat:@"%@",[_dic objectForKey:@"status"]] isEqualToString:@"<null>"])
                [_obj setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"status"]] forKey:@"status"];
            
            [_data addObject:_obj];
            [_obj release];
        }
        
        [self setAccounts:_data];
        [_data release];
    }
    
    [response release];
    [gcRequest release];
    [_path release];
}

// Public: Same as loadAccounts but runs in background and executes a completion block after
// the accounts are done loading.
//
// aCompletionBlock - The block of code to run after loading the assets
//
// No return value.
-(void)loadAccountsInBackgroundWithCompletion:(void (^)(void))aCompletionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        [self loadAccounts];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (aCompletionBlock) {
                aCompletionBlock();
            }
        });
    });
}

- (GCResponse*) albumsForAccount:(NSString*)accountID{
    if(!accountID){
        GCResponse *response = [[GCResponse alloc] init];
        NSMutableDictionary *_errorDetail = [NSMutableDictionary dictionary];
        [_errorDetail setValue:@"No account ID entered" forKey:NSLocalizedDescriptionKey];
        [response setError:[GCError errorWithDomain:@"GCError" code:401 userInfo:_errorDetail]];
        return [response autorelease];
    }
    NSString *_path = [NSString stringWithFormat:@"%@accounts/%@/objects", API_URL,accountID];
    GCRequest *gcRequest = [[GCRequest alloc] init];
    
    GCResponse *response = [[gcRequest getRequestWithPath:_path] retain];
    
    if ([response isSuccessful]) {
        [response setObject:[response data]];
    }
    return [response autorelease];
}

-(void)albumsForAccount:(NSString *)accountID inBackgroundWithResponse:(GCResponseBlock)aResponseBlock{
    DO_IN_BACKGROUND([self albumsForAccount:accountID], aResponseBlock);
}

- (GCResponse*) photosForAccount:(NSString*)accountID andAlbum:(NSString*)albumID{
    if(!accountID){
        GCResponse *response = [[GCResponse alloc] init];
        NSMutableDictionary *_errorDetail = [NSMutableDictionary dictionary];
        [_errorDetail setValue:@"No account ID entered" forKey:NSLocalizedDescriptionKey];
        [response setError:[GCError errorWithDomain:@"GCError" code:401 userInfo:_errorDetail]];
        return [response autorelease];
    }
    if(!albumID){
        GCResponse *response = [[GCResponse alloc] init];
        NSMutableDictionary *_errorDetail = [NSMutableDictionary dictionary];
        [_errorDetail setValue:@"No album ID entered" forKey:NSLocalizedDescriptionKey];
        [response setError:[GCError errorWithDomain:@"GCError" code:401 userInfo:_errorDetail]];
        return [response autorelease];
    }

    NSString *_path = [NSString stringWithFormat:@"%@accounts/%@/objects/%@", API_URL,accountID,albumID];
    GCRequest *gcRequest = [[GCRequest alloc] init];
    
    GCResponse *response = [[gcRequest getRequestWithPath:_path] retain];
    
    if ([response isSuccessful]) {
        [response setObject:[response data]];
    }
    return [response autorelease];
}

-(void)photosForAccount:(NSString *)accountID andAlbum:(NSString *)albumID inBackgroundWithResponse:(GCResponseBlock)aResponseBlock{
    DO_IN_BACKGROUND([self photosForAccount:accountID andAlbum:albumID], aResponseBlock);
}

#pragma mark - Load Assets

// Public: Loads an array of GCAssets from the Camera Roll of the device into assetsArray.
// The array is in reverse chronological order, so the newest photos are first.
// When done it runs aCompletionBlock.
//
// aCompletionBlock - A Block to be ran after the assets are done loading.
//
// No return value.
- (void)loadAssetsCompletionBlock:(void (^)(void))aCompletionBlock{
    [self loadAssetsCompletionBlock:aCompletionBlock andFailure:nil]; 
}

- (void)loadAssetsCompletionBlock:(void (^)(void))aCompletionBlock andFailure:(void (^)(void))aFailureBlock{
        if (assetsArray) {
            [assetsArray release], assetsArray = nil;
        }
        
        assetsArray = [[NSMutableArray alloc] init];
        
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
        {
            if(result != nil)
            {
                GCAsset *_asset = [[GCAsset alloc] init];
                [_asset setAlAsset:result];
                [assetsArray insertObject:_asset atIndex:0];
                [_asset release];
            }
        };
        
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group == nil) {
                if (aCompletionBlock) {
                    aCompletionBlock();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DONE_LOADING_ASSETS" object:nil];
                return;
            }
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:assetEnumerator];
        };
        
        void (^assetFailureBlock)(NSError *) = ^(NSError *error)
        {
            if(aFailureBlock){
                aFailureBlock();
            }
        };
        
        if(!self.assetsLibrary){
            ALAssetsLibrary *temp = [[ALAssetsLibrary alloc] init];
            [self setAssetsLibrary:temp];
            [temp release];
        }
        
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetGroupEnumerator failureBlock:assetFailureBlock];
}

// Public: Same as loadAssetsCompletionBlock with a nil completion block.
//
// No return value.
- (void)loadAssets {
    [self loadAssetsCompletionBlock:nil];
}

#pragma mark - Accounts

// Public: retains an array of dictionaries representing accounts, saves it to the user defaults
// and set's it to the accounts object
//
// aAccounts - the array of dictionary representations of accounts to set
//
// No return value.
- (void) setAccounts:(NSMutableArray *)aAccounts {
    if (_accounts) {
        [_accounts release], _accounts = nil;
    }
    if(!aAccounts){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:nil forKey:@"accounts"];
        [prefs synchronize];
        return;
    }
    _accounts = [aAccounts retain];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:_accounts forKey:@"accounts"];
    [prefs synchronize];
}

// Public: Gets the value stored in accounts; loads it from
// user defaults if it's nil.
//
// Returns the array of user's accounts
- (NSMutableArray *) accounts {
    if (_accounts == nil) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _accounts = [[prefs objectForKey:@"accounts"] retain];
    }
    return _accounts;
}

#pragma mark - Access Token

// Public: Set's the access token for the Chute API and saves it to user defaults.
//
// accessTkn - The access token to be saved
//
// No return value.
- (void) setAccessToken:(NSString *)accessTkn {
    if (_accessToken) {
        [_accessToken release], _accessToken = nil;
    }
    _accessToken = [accessTkn retain];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:_accessToken forKey:@"access_token"];
    [prefs synchronize];
}

// Public: Get's the access token for the Chute API, loads from user defaults if it's nil
//
// Returns the access token.
- (NSString *) accessToken {
    if (_accessToken == nil) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _accessToken = [[prefs objectForKey:@"access_token"] retain];
    }
    return _accessToken;
}

#pragma mark - User id

// Public: saves the userId to user defaults
//
// userid - the id to save
//
// No return value
- (void) setUserId:(NSString*) userId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:userId forKey:@"user_id"];
    [prefs synchronize];
}

// Public: retrieve the saved user ID
//
// Returns the user ID saved in user defaults
- (NSString*) userId {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%@",[prefs objectForKey:@"user_id"]];
}

#pragma mark - Authorization Methods

// Public: set the current account status.  Sends a notification that the status has changed
// If the user has just logged in then it also loads the user's hearted assets.
//
// _accountStatus - the new account status to set
//
// No return value.
- (void) setAccountStatus:(GCAccountStatus)_accountStatus {
    accountStatus = _accountStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:GCAccountStatusChanged object:self];
    
    if (_accountStatus == GCAccountLoggedIn) {
        [self loadHeartedAssets];
    }
}

// Private: Combines the user account given by the info parameter with the current logged in user account.
//
// info - a dictionary representing the account to merge.  It is a dictionary with the new account's access token saved to the key access_token
// aResponseBlock - a block of code to run after the merge is completed
//
// No return value.
- (void)moveToExistingUserWithInfo:(NSMutableDictionary *)info 
                      withResponse:(GCResponseBlock)aResponseBlock {
    
    NSString *_path = [[NSString alloc] initWithFormat:@"%@me/accounts/move", API_URL];
    GCRequest *gcRequest = [[GCRequest alloc] init];
    
    [gcRequest postRequestInBackgroundWithPath:_path 
                                     andParams:info
                                  withResponse:^(GCResponse *response) {
                                      if (aResponseBlock) {
                                          aResponseBlock(response);
                                      }
                                  }];
    
    
    [gcRequest release];
    [_path release];
}

// Public: Uses the Access code recieved during login to retrieve an access token.
// Runs a block of code on success or failure.  Also updates the account status and
// retrives the user's profile information.
//
// accessCode - the access code used to verify the user and retrive an access token
// successBlock - a block of code tobe ran after successfully getting the access token
// errorBock - A block of code to run if the request for an access token fails
//
// No return value.
- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(GCBasicBlock)successBlock 
                                  andError:(GCErrorBlock)errorBlock {
    if ([self accessToken] && !accessCode) {
        [self setAccountStatus:GCAccountLoggedIn];
        successBlock();
        return;
    }
    
    [self setAccountStatus:GCAccountLoggingIn];
    
    NSDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:kOAuthPermissions forKey:@"scope"];
    [params setValue:kOAuthAppID forKey:@"client_id"];
    [params setValue:kOAuthAppSecret forKey:@"client_secret"];
    [params setValue:@"authorization_code" forKey:@"grant_type"];
    [params setValue:kOAuthCallbackURL forKey:@"redirect_uri"];
    
    if (accessCode == nil) {
        errorBlock(nil);
        return;
    }
    else {
        [params setValue:accessCode forKey:@"code"];
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kOAuthTokenURL]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request appendPostData:[[params stringWithFormEncodedComponents] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:self];
    
    [request setTimeOutSeconds:300.0];
    [request setCompletionBlock:^{
        
        //save access code
        NSDictionary *_response = [[request responseString] JSONValue];
        
        // there is a existing token that exists, so just attach the new user to the old one
        // this will move new user's accounts over to the old user
        NSString *_existingToken = [[GCAccount sharedManager] accessToken];
        
        // new code by - gaurav
        if (_existingToken) {
            NSMutableDictionary *_info = [NSMutableDictionary dictionaryWithObject:[_response objectForKey:@"access_token"] forKey:@"access_token"];
            [self moveToExistingUserWithInfo:_info withResponse:^(GCResponse *response) {
                [self setAccountStatus:GCAccountLoggedIn];
                successBlock();
            }];
        } else {
            [self setAccessToken:[_response objectForKey:@"access_token"]];
            //send request to save userid
            [self getProfileInfoWithResponse:^(GCResponse *response) {
                if ([response error]) {
                    [self setAccountStatus:GCAccountLoginFailed];
                    errorBlock([response error]);
                }
                else {
                    [self loadAccounts];
                    [self setUserId:[NSString stringWithFormat:@"%@",[[response object] valueForKey:@"id"]]];
                    [self setAccountStatus:GCAccountLoggedIn];
                    successBlock();
                }
            }];
        }
    }];
    
    [request setFailedBlock:^{
        [self setAccountStatus:GCAccountLoginFailed];
        errorBlock([request error]);
    }];
    [request startAsynchronous];
}

#pragma mark - Get Profile Info

// Public: Get's the profile inormation from the Chute service for the current user
// then runs a response block.
//
// aResponseBlock - a block of code to run after the request for profile info is finished
//
// no return value
- (void)getProfileInfoWithResponse:(GCResponseBlock)aResponseBlock {
    NSString *_path = [[NSString alloc] initWithFormat:@"%@me", API_URL];
    GCRequest *gcRequest = [[GCRequest alloc] init];
    
    [gcRequest getRequestInBackgroundWithPath:_path withResponse:^(GCResponse *response) {
        if (aResponseBlock) {
            aResponseBlock(response);
        }
    }];
    
    [gcRequest release];
    [_path release];
}

// Public: logs out the user.  Clears the access token and user id.
//
// No return value
- (void)reset {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"access_token"];
    [prefs setObject:nil forKey:@"id"];
    [prefs setObject:nil forKey:@"accounts"];
    [prefs synchronize];
    [ASIHTTPRequest setSessionCookies:nil];
    if (_accessToken) {
        [_accessToken release], _accessToken = nil;
    }
    [self setAccounts:NULL];
}

#pragma mark - My Meta Data Methods

// Public: Retrive all metadata for the current user
// Makes the request from the calling thread.
//
// Returns a GCResponse that has either a metadata dictionary for it's data object, or has an error object.
- (GCResponse *) getMyMetaData {
    NSString *_path              = [[NSString alloc] initWithFormat:@"%@me/meta", API_URL];
    GCRequest *gcRequest         = [[GCRequest alloc] init];
    GCResponse *_response        = [[gcRequest getRequestWithPath:_path] retain];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

// Public: Same as getMyMetadata except it makes the request on a background thread
// and runs a response block after the request is completed
//
// aResponseBlock- a block of code to be executed after the request completes.
//
// No return value
- (void) getMyMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self getMyMetaData], aResponseBlock);
}

// Public: Sets a dictionary of key/value pairs to the current user's metadata.
// if any of the keys exist already they're value will be overwritten with the new value.
//
// metaData - the dictionary to set to the user's metadata
//
// Returns a BOOL indicating if the metadata was successfully set or not
- (BOOL) setMyMetaData:(NSDictionary *) metaData {
    NSMutableDictionary *_params = [[NSMutableDictionary alloc] init];
    [_params setValue:[[metaData JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"raw"];
    
    NSString *_path             = [[NSString alloc] initWithFormat:@"%@me/meta", API_URL];
    
    GCRequest *gcRequest        = [[GCRequest alloc] init];
    BOOL _response              = [[gcRequest postRequestWithPath:_path andParams:_params] isSuccessful];
    [gcRequest release];
    [_path release];
    [_params release];
    return _response;
}

// Public: Same as setMyMetaData except it runs in the background and executes a block of code after completion.
//
// metaData - the dictionary to set to the user's metadata
// aBoolBlock - a block of code to be ran after the request completes
//
// No return value
- (void) setMyMetaData:(NSDictionary *) metaData inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock {
    DO_IN_BACKGROUND_BOOL([self setMyMetaData:metaData], aBoolBlock);
}


#pragma mark - Get Inbox Parcels

// Public: Retrieves the most recent parcels that have been added to the chutes the current user is subscribed to
//
// Returns a GCResponse that has an array of GCParcels set for it's object if the request successful
// or an error object if the request failed
- (GCResponse *) getInboxParcels {
    NSString *_path              = [[NSString alloc] initWithFormat:@"%@inbox/parcels", API_URL];
    GCRequest *gcRequest         = [[GCRequest alloc] init];
    GCResponse *_response        = [[gcRequest getRequestWithPath:_path] retain];
    NSMutableArray *_parcels = [[NSMutableArray alloc] init];
    for (NSDictionary *_dic in [_response data]) {
        [_parcels addObject:[GCParcel objectWithDictionary:_dic]];
    }
    [_response setObject:_parcels];
    [_parcels release];
    [gcRequest release];
    [_path release];
    return [_response autorelease];
}

// Public: Same as getInboxParcels except it runs in the background and executes a block of code on completion
//
// aResponseBlock- a block of code to be executed after the request completes.
//
// No return value
- (void) getInboxParcelsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock {
    DO_IN_BACKGROUND([self getInboxParcels], aResponseBlock);
}

// Public: Retrives an array of the current user's hearted assets and stores them in heartedAssets
//
// No return value
- (void) loadHeartedAssets {
    if (heartedAssets) {
        [heartedAssets release], heartedAssets = nil;
        
    }
    
    //heartedAssets = [[NSMutableArray alloc] init];
    
    [GCChute findByShortcut:@"heart" inBackgroundWithCompletion:^(GCResponse *response) {
        if ([response isSuccessful]) {
            [[response object] assetsInBackgroundWithCompletion:^(GCResponse *response) {
                [self setHeartedAssets:[response object]]; 
            }];
        }
    }];
}

#pragma mark - Methods for Singleton class

-(id)init{
    self = [super init];
    if(self){
        assetLock = [[NSLock alloc] init];
    }
    return self;
}

+ (GCAccount *)sharedManager
{
    if (sharedAccountManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedAccountManager = [[super allocWithZone:NULL] init];
        });
    }
    return sharedAccountManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release;
{
    //nothing
}

- (id)autorelease
{
    return self;
}

@end
