//
//  BVCurationsFeeditem.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCore.h"
#import "BVCurationsFeedItem.h"

@interface BVCurationsFeedItem()

@property bool hasSentImpressionEvent;

@end

@implementation BVCurationsFeedItem

-(id)initWithDict:(NSDictionary*)dict withReferencedProducts:(NSDictionary *)referencedProducts withExternalId:(NSString *)externalId {

    self = [self initWithDict:dict withReferencedProducts:referencedProducts];
    
    if (self){
        
        self.externalId = externalId;
        
    }
    
    return self;
    
}

-(id)initWithDict:(NSDictionary*)dict withReferencedProducts:(NSDictionary *)referencedProducts {
    self = [super init];
    if(self){
        
        if (dict != nil){
        
            self.channel = [dict objectForKey:@"channel"];
            self.contentId = [dict objectForKey:@"id"];
            self.rating = [dict objectForKey:@"rating"];
            self.classification = [dict objectForKey:@"classification"];
            self.text = [dict objectForKey:@"text"];
            self.identifier = [dict objectForKey:@"id"];
            self.praises = [dict objectForKey:@"praises"];
            self.explicitPermissionStatus = [dict objectForKey:@"explicit_permission_status"];
            self.author = [[BVCurationsPostAuthor alloc] initWithDict:[dict objectForKey:@"author"]];
            self.links = [dict objectForKey:@"links"];
            self.coordinates = [[BVCurationsCoordinates alloc] initWithDict:[dict objectForKey:@"coordinates"]];
            self.featuredGroups = [dict objectForKey:@"featured_groups"];
            self.videos = [self getVideos:[dict objectForKey:@"videos"]];
            self.tags = [dict objectForKey:@"tags"];
            self.timestamp = [dict objectForKey:@"timestamp"];
            self.photos = [self getPhotos:[dict objectForKey:@"photos"]];
            self.teaser = [dict objectForKey:@"teaser"];
            self.groups = [dict objectForKey:@"groups"];
            self.permalink = [dict objectForKey:@"permalink"];
            self.language = [dict objectForKey:@"language"];
            self.token = [dict objectForKey:@"token"];
            self.place = [dict objectForKey:@"place"];
            self.replyTo = [dict objectForKey:@"reply_to"];
            self.sourceClient = [dict objectForKey:@"sourceClient"];
            
            // If we have tags and referenced products we can build the product dictionary model
            
            self.referencedProducts = [NSArray array];
            if (referencedProducts != nil && self.tags != nil && referencedProducts.allKeys.count > 0 && self.tags.count > 0){
                
                NSMutableArray *tmpProducts = [NSMutableArray array];
                
                for (NSString *tag in self.tags){
                    
                    BVCurationsProductDetail *item = [referencedProducts objectForKey:tag];
                    if (item){
                        
                        [tmpProducts addObject:item];
                        
                    }
                    
                }
                
                self.referencedProducts = [NSArray arrayWithArray:tmpProducts];
                
            }
                    
        }
        
    }
    return self;
}

-(NSArray<BVCurationsPhoto*>*)getPhotos:(NSDictionary*)arrayOfPhotos {
    NSMutableArray* photos = [NSMutableArray array];
    
    for(NSDictionary* photo in arrayOfPhotos){
        [photos addObject:[[BVCurationsPhoto alloc] initWithDict:photo]];
    }
    
    return photos;
}

-(NSArray<BVCurationsVideo*>*)getVideos:(NSDictionary*)arrayOfVideos {
    NSMutableArray* videos = [NSMutableArray array];
    
    for(NSDictionary* video in arrayOfVideos){
        [videos addObject:[[BVCurationsVideo alloc] initWithDict:video]];
    }
    
    return videos;
}

-(void)recordImpression {
    
    if(self.hasSentImpressionEvent) {
        return;
    }
    self.hasSentImpressionEvent = true;
    
    BVImpressionEvent *impression = [[BVImpressionEvent alloc] initWithProductId:self.externalId
                                                                   withContentId:self.contentId
                                                                  withCategoryId:nil
                                                          withProductType:BVPixelProductTypeCurations
                                                                 withContentType:BVPixelImpressionContentCurationsFeedItem withBrand:nil
                                                            withAdditionalParams:@{@"syndicationSource":self.sourceClient}];
    
    [BVPixel trackEvent:impression];
    
}

-(void)recordTap {
    
    BVFeatureUsedEvent *tapEvent = [[BVFeatureUsedEvent alloc] initWithProductId:self.externalId
                                                       withBrand:nil
                                          withProductType:BVPixelProductTypeCurations
                                                   withEventName:BVPixelFeatureUsedEventContentClick withAdditionalParams:nil];
    
    [BVPixel trackEvent:tapEvent];
}


- (NSString *)description{
    
    return [NSString stringWithFormat:@"Curations Feed Item: Channel: %@ - Text: %@", self.channel, self.text];
}

@end


@implementation BVCurationsCoordinates

-(id)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        
        if (dict != nil){
        
            SET_IF_NOT_NULL(self.latitude, [dict objectForKey:@"latitude"])
            SET_IF_NOT_NULL(self.longitude, [dict objectForKey:@"longitude"])
            
        }
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"Locations: Lat:%@ / Long:%@", [NSString stringWithFormat:@"%@",self.latitude], [NSString stringWithFormat:@"%@",self.latitude]];
}

@end

@implementation BVCurationsPhoto

-(id)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        
        if (dict != nil){
        
            SET_IF_NOT_NULL(self.origin, [dict objectForKey:@"origin"])
            SET_IF_NOT_NULL(self.permalink, [dict objectForKey:@"permalink"])
            SET_IF_NOT_NULL(self.token, [dict objectForKey:@"dict"])
            SET_IF_NOT_NULL(self.role, [dict objectForKey:@"role"])
            SET_IF_NOT_NULL(self.displayUrl, [dict objectForKey:@"display_url"])
            SET_IF_NOT_NULL(self.url, [dict objectForKey:@"url"])
            SET_IF_NOT_NULL(self.imageServiceUrl, [dict objectForKey:@"image_service_url"])
            SET_IF_NOT_NULL(self.identifier, [dict objectForKey:@"id"])
            SET_IF_NOT_NULL(self.localUrl, [dict objectForKey:@"id"])
                
        }
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"Photo: Origin: %@, URL: %@", self.origin, self.imageServiceUrl ];
}

@end


@implementation BVCurationsVideo

-(id)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        
        if (dict != nil){
        
            SET_IF_NOT_NULL(self.origin, [dict objectForKey:@"origin"])
            SET_IF_NOT_NULL(self.permalink, [dict objectForKey:@"permalink"])
            SET_IF_NOT_NULL(self.code, [dict objectForKey:@"code"])
            SET_IF_NOT_NULL(self.imageUrl, [dict objectForKey:@"image_url"])
            SET_IF_NOT_NULL(self.token, [dict objectForKey:@"token"])
            SET_IF_NOT_NULL(self.displayUrl, [dict objectForKey:@"display_url"])
            SET_IF_NOT_NULL(self.imageServiceUrl, [dict objectForKey:@"image_service_url"])
            SET_IF_NOT_NULL(self.identifier, [dict objectForKey:@"id"])
            SET_IF_NOT_NULL(self.remoteUrl, [dict objectForKey:@"remote_url"])
            SET_IF_NOT_NULL(self.videoType, [dict objectForKey:@"video_type"])
        
        }
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"Photo: Origin: %@, URL: %@", self.origin, self.imageServiceUrl ];
}

@end


@implementation BVCurationsPostAuthor

-(id)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if(self){
        
        if (dict != nil){
        
            SET_IF_NOT_NULL(self.profile, [dict objectForKey:@"profile"])
            SET_IF_NOT_NULL(self.username, [dict objectForKey:@"username"])
            SET_IF_NOT_NULL(self.alias, [dict objectForKey:@"alias"])
            SET_IF_NOT_NULL(self.token, [dict objectForKey:@"token"])
            SET_IF_NOT_NULL(self.avatar, [dict objectForKey:@"avatar"])
            SET_IF_NOT_NULL(self.channel, [dict objectForKey:@"channel"])
            
        }
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"Photo: Usename: %@, Channel: %@", self.username, self.channel];
}

@end

@implementation BVCurationsProductDetail

@synthesize identifier;
@synthesize displayImageUrl;
@synthesize displayName;
@synthesize averageRating;

-(id)initWithDict:(NSDictionary*)dict withKey:(NSString *)key {
    
    self = [super init];
    if(self){
        
        if (dict != nil){
            
            self.productKey = key;
            SET_IF_NOT_NULL(self.productId, [dict objectForKey:@"Id"])
            SET_IF_NOT_NULL(self.productImageUrl, [dict objectForKey:@"ImageUrl"])
            SET_IF_NOT_NULL(self.productName, [dict objectForKey:@"Name"])
            SET_IF_NOT_NULL(self.productPageUrl, [dict objectForKey:@"ProductPageUrl"])
            SET_IF_NOT_NULL(self.productDescription, [dict objectForKey:@"Description"])
            
            self.totalReviewCount = [NSNumber numberWithInteger:0];
            self.avgRating = [NSNumber numberWithFloat:0.0];
            
            SET_IF_NOT_NULL(self.totalReviewCount, [dict objectForKey:@"TotalReviewCount"]);
            
            if (self.totalReviewCount > 0 && [dict objectForKey:@"ReviewStatistics"] != nil){
                SET_IF_NOT_NULL(self.avgRating, [[dict objectForKey:@"ReviewStatistics"] objectForKey:@"AverageOverallRating"]);
            }
            
        }
    
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"Key: %@, ID: %@ Title: %@, Rating: %.02f(%ld)", self.productKey, self.productId, self.productName, [self.avgRating floatValue], (long)[self.totalReviewCount integerValue]];
}

-(NSString*)displayName {
    return _productName;
}

-(NSString*)displayImageUrl {
    return _productImageUrl;
}

-(NSString*)identifier {
    return _productId;
}

-(NSNumber*)averageRating {
    return _avgRating;
}

@end
