//
//  NSDictionary+GCAccountAsset.m
//  PhotoPickerPlus-SampleApp
//
//  Created by ARANEA on 8/30/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "NSDictionary+GCAccountAsset.h"
#import "GCAccountAssets.h"
#import <Chute-SDK/GCAsset.h>

@implementation NSDictionary (GCAccountAsset)

+ (NSDictionary *)dictionaryFromGCAccountAssets:(GCAccountAssets *)asset
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:asset.id forKey:@"id"];
    [dictionary setValue:asset.caption forKey:@"caption"];
    [dictionary setValue:asset.thumbnail forKey:@"thumbnail"];
    [dictionary setValue:asset.image_url forKey:@"image_url"];
    [dictionary setValue:asset.video_url forKey:@"video_url"];
    [dictionary setValue:asset.dimensions forKey:@"dimensions"];
    
    return dictionary;
}

+ (NSDictionary *)infoFromGCAccountAsset:(GCAccountAssets *)asset
{
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:@"ALAssetTypePhoto" forKey:UIImagePickerControllerMediaType];
    [mediaInfo setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[asset image_url]]]] forKey:UIImagePickerControllerOriginalImage];
    [mediaInfo setObject:[NSURL URLWithString:[asset image_url]] forKey:UIImagePickerControllerReferenceURL];
    
    return mediaInfo;
    
}

+ (NSDictionary *)infoFromGCAsset:(GCAsset *)asset
{
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:@"ALAssetTypePhoto" forKey:UIImagePickerControllerMediaType];
    [mediaInfo setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[asset url]]]] forKey:UIImagePickerControllerOriginalImage];
    [mediaInfo setObject:[NSURL URLWithString:[asset url]] forKey:UIImagePickerControllerReferenceURL];
    
    return mediaInfo;
    
}
@end
