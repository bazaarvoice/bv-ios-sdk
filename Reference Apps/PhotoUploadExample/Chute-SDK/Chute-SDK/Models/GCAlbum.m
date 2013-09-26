//
//  GCAlbum.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 2/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCAlbum.h"
#import "GCClient.h"
#import "AFJSONRequestOperation.h"
#import "DCKeyValueObjectMapping.h"
#import "GCAsset.h"
#import "GCServiceAsset.h"
#import "GCServiceAlbum.h"

@implementation GCAlbum

@synthesize id = _id, links = _links, counters = _counters, shortcut = _shortcut, name = _name, user = _user, moderateMedia = _moderateMedia, moderateComments = _moderateComments, createdAt = _createdAt, updatedAt = _updatedAt, description = _description;

+ (void)getAllAlbumsWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *albums, GCPagination *pagination))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum getAlbumsWithSuccess:^(GCResponseStatus *response, NSArray *albums, GCPagination *pagination) {
        success(response,albums,pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getAlbumWithSuccess:(void(^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum getAlbumWithID:self.id success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus,album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)createAlbumWithName:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure
{
    
    [GCServiceAlbum createAlbumWithName:name moderateMedia:moderateMedia moderateComments:moderateComments success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus, album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)updateAlbumWithName:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure
{
    [GCServiceAlbum updateAlbumWithID:self.id name:name moderateMedia:moderateMedia moderateComments:moderateComments success:^(GCResponseStatus *responseStatus, GCAlbum *album) {
        success(responseStatus, album);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteAlbumWithSuccess:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum deleteAlbumWithID:self.id success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)addAssets:(NSArray *)asssetsArray success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum addAssets:asssetsArray ForAlbumWithID:self.id success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)removeAssets:(NSArray *)asssetsArray success:(void(^)(GCResponseStatus *responseStatus))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAlbum removeAssets:asssetsArray ForAlbumWithID:self.id success:^(GCResponseStatus *responseStatus) {
        success(responseStatus);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getAssetWithID:(NSNumber *)assetID success:(void(^)(GCResponseStatus *responseStatus, GCAsset *asset))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAsset getAssetWithID:assetID fromAlbumWithID:self.id success:^(GCResponseStatus *responseStatus, GCAsset *asset) {
        success(responseStatus,asset);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getAllAssetsWithSuccess:(void(^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAsset getAssetsForAlbumWithID:self.id success:^(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination) {
        success(responseStatus,assets,pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)importAssetsFromURLs:(NSArray *)urls success:(void(^)(GCResponseStatus *responseStatus, NSArray *assets, GCPagination *pagination))success failure:(void(^)(NSError *error))failure
{
    [GCServiceAsset importAssetsFromURLs:urls forAlbumWithID:self.id success:^(GCResponseStatus *reponseStatus, NSArray *assets, GCPagination *pagination) {
        success(reponseStatus, assets, pagination);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
