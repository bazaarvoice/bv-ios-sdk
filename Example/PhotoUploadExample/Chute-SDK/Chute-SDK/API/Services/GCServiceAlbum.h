//
//  GCServiceAlbum.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 3/26/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCResponseStatus, GCAlbum, GCPagination;

@interface GCServiceAlbum : NSObject

+ (void)getAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;
+ (void)getAlbumsWithSuccess:(void (^)(GCResponseStatus *response, NSArray *albums, GCPagination *pagination))success
                     failure:(void (^)(NSError *error))failure;
+ (void)createAlbumWithName:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;
+ (void)updateAlbumWithID:(NSNumber *)albumID name:(NSString *)name moderateMedia:(BOOL)moderateMedia moderateComments:(BOOL)moderateComments success:(void (^)(GCResponseStatus *responseStatus, GCAlbum *album))success failure:(void (^)(NSError *error))failure;
+ (void)deleteAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure;
+ (void)addAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure;
+ (void)removeAssets:(NSArray *)assetsArray ForAlbumWithID:(NSNumber *)albumID success:(void (^)(GCResponseStatus *responseStatus))success failure:(void (^)(NSError *error))failure;


@end
