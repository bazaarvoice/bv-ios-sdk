//
//  GCChute.h
//
//  Created by Achal Aggarwal on 01/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

typedef enum {
    GCPermissionTypePrivate = 0,
    GCPermissionTypeMembers,
    GCPermissionTypePublic,
    GCPermissionTypeFriends,
    GCPermissionTypePassword
} GCPermissionType;

@interface GCChute : GCResource

@property (nonatomic, readonly) NSUInteger assetsCount;
@property (nonatomic, readonly) NSUInteger contributersCount;
@property (nonatomic, readonly) NSUInteger membersCount;

@property (nonatomic, assign) GCPermissionType moderateComments;
@property (nonatomic, assign) GCPermissionType moderateMembers;
@property (nonatomic, assign) GCPermissionType moderatePhotos;

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *password;

@property (nonatomic, assign) GCPermissionType permissionAddComments;
@property (nonatomic, assign) GCPermissionType permissionAddMembers;
@property (nonatomic, assign) GCPermissionType permissionAddPhotos;
@property (nonatomic, assign) GCPermissionType permissionView;

@property (nonatomic, readonly) NSUInteger recentCount;
@property (nonatomic, readonly) NSUInteger recentParcelId;

@property (nonatomic, readonly) NSString *recentThumbnailUrl;

@property (nonatomic, readonly) NSUInteger recentUserId;

@property (nonatomic, readonly) NSString *shortcut;

- (GCResponse *) assets;
- (void) assetsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (GCResponse *) contributors;
- (void) contributorsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (GCResponse *) members;
- (void) membersInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (BOOL) join;
- (void) joinInBackgroundWithBOOLCompletion:(GCBoolBlock) aResponseBlock;

- (BOOL) joinWithPassword:(NSString *) _password;
- (void) joinWithPassword:(NSString *) _password inBackgroundWithBOOLCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) leave;
- (void) leaveInBackgroundWithBOOLCompletion:(GCBoolBlock) aResponseBlock;

- (BOOL) setEventID:(NSString*)eventID forEventType:(NSString*)eventType;
- (void) setEventID:(NSString*)eventID forEventType:(NSString*)eventType inBackgroundWithBOOLCompletion:(GCBoolBlock) aBoolBlock;

+ (GCResponse *)allPublic;
+ (void)allPublicInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

+ (GCResponse *)allFriends;
+ (void)allFriendsInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

@end
