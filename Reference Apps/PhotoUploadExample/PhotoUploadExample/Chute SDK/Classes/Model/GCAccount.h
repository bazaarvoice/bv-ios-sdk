//
//  GCAccount.h
//
//  Created by Achal Aggarwal on 30/08/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GetChute.h"

//Notification which is fired whenever the Account Status is changed
NSString * const GCAccountStatusChanged;

typedef enum {
    GCAccountLoggedOut,
    GCAccountLoggingIn,
    GCAccountLoggedIn,
    GCAccountLoginFailed
} GCAccountStatus;

@interface GCAccount : NSObject {
    GCAccountStatus accountStatus;
    NSString *_accessToken;
    NSMutableArray *assetsArray;
    
    NSMutableArray *heartedAssets;
    
    NSMutableArray *_accounts;
    ALAssetsLibrary *assetsLibrary;
    NSLock *assetLock;
}

@property (nonatomic) GCAccountStatus accountStatus;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSMutableArray *assetsArray;
@property (nonatomic, retain) NSMutableArray *heartedAssets;

@property (nonatomic, retain) NSMutableArray *accounts;

@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;

+ (GCAccount *)sharedManager;

- (NSString*) userId;

- (void)loadAssets;
- (void)loadAssetsCompletionBlock:(void (^)(void))aCompletionBlock;
- (void)loadAssetsCompletionBlock:(void (^)(void))aCompletionBlock andFailure:(void (^)(void))aFailureBlock;

- (void) verifyAuthorizationWithAccessCode:(NSString *) accessCode 
                                   success:(GCBasicBlock)successBlock 
                                  andError:(GCErrorBlock)errorBlock;
- (void)reset;

- (void)getProfileInfoWithResponse:(GCResponseBlock)aResponseBlock;

- (GCResponse *) getMyMetaData;
- (void) getMyMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (BOOL) setMyMetaData:(NSDictionary *) metaData;
- (void) setMyMetaData:(NSDictionary *) metaData inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (GCResponse *) getInboxParcels;
- (void) getInboxParcelsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (void) loadHeartedAssets;

- (void) loadAccounts;
-(void)loadAccountsInBackgroundWithCompletion:(void (^)(void))aCompletionBlock;

- (GCResponse*) albumsForAccount:(NSString*)accountID;
- (void) albumsForAccount:(NSString*)accountID inBackgroundWithResponse:(GCResponseBlock)aResponseBlock;
- (GCResponse*) photosForAccount:(NSString*)accountID andAlbum:(NSString*)albumID;
- (void) photosForAccount:(NSString*)accountID andAlbum:(NSString*)albumID inBackgroundWithResponse:(GCResponseBlock)aResponseBlock;

@end
