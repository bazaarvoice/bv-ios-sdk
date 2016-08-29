//
//  BVCurationsFeeditem.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

// Forward declarations: classes are contained in a BVCurationsFeedItem object.
@class BVCurationsCoordinates;
@class BVCurationsPhoto;
@class BVCurationsVideo;
@class BVCurationsPostAuthor;
@class BVCurationsProductDetail;

/// Top-level Curations model object in a Curations feed.
@interface BVCurationsFeedItem : NSObject

    @property NSString* channel;
    @property NSString* contentId;
    @property NSNumber* rating;
    @property NSString* classification;
    @property NSString* text;
    @property NSNumber* identifier;
    @property NSNumber* praises;
    @property NSString* explicitPermissionStatus;
    @property BVCurationsPostAuthor* author;
    @property NSArray< NSString* >* links;
    @property BVCurationsCoordinates* coordinates;
    @property NSArray< NSString* >* featuredGroups;
    @property NSArray< NSString* >* tags;
    @property NSNumber* timestamp;
    @property NSArray <BVCurationsPhoto *> *photos;
    @property NSArray <BVCurationsVideo *> *videos;
    @property NSArray <BVCurationsProductDetail *> *referencedProducts;
    @property NSDictionary *productDetails;
    @property NSString* teaser;
    @property NSArray< NSString* >* groups;
    @property NSString* permalink;
    @property NSString* productId;
    @property NSString* language;
    @property NSString* token;
    @property NSString* place;
    @property NSString* replyTo;
    @property NSString* sourceClient;

    /// As provided by the external ID BVCurationsFeedParams value. When supplied, this is used as the product Id for analytics reporting.
    @property NSString *externalId;

    -(id)initWithDict:(NSDictionary*)dict withReferencedProducts:(NSDictionary *)referencedProducts;

    -(id)initWithDict:(NSDictionary*)dict withReferencedProducts:(NSDictionary *)referencedProducts withExternalId:(NSString *)exernalId;

    -(void)recordTap;

    -(void)recordImpression;

@end


/// Lat/Long coordinates for a given BVCurationsFeedItem objects. Items may be nil.
@interface BVCurationsCoordinates : NSObject

    @property NSNumber* latitude;
    @property NSNumber* longitude;

    -(id)initWithDict:(NSDictionary*)dict;

@end


/// Attributes for a single photo in a BVCurationsFeedItem object.
@interface BVCurationsPhoto : NSObject

    @property NSString* origin;
    @property NSString* permalink;
    @property NSString* token;
    @property NSString* role;
    @property NSString* displayUrl;
    @property NSString* url;
    @property NSString* imageServiceUrl;
    @property NSNumber* identifier;
    @property NSString* localUrl;

    -(id)initWithDict:(NSDictionary*)dict;

@end


/// Attributes for a single video in a BVCurationsFeedItem object.
@interface BVCurationsVideo : NSObject

    @property NSString* origin;
    @property NSString* permalink;
    @property NSString* code;
    @property NSString* imageUrl;
    @property NSString* token;
    @property NSString* displayUrl;
    @property NSString* imageServiceUrl;
    @property NSNumber* identifier;
    @property NSString* remoteUrl;
    @property NSString* videoType;

    -(id)initWithDict:(NSDictionary*)dict;

@end


/// Attributes the author of a single BVCurationsFeedItem object.
@interface BVCurationsPostAuthor : NSObject

    @property NSString* profile;
    @property NSString* username;
    @property NSString* alias;
    @property NSString* token;
    @property NSString* avatar;
    @property NSString* channel;

    -(id)initWithDict:(NSDictionary*)dict;

@end


/// Attributes for a single product reference. This object is referenced by a single BVCurationsFeedItem and can be used to show the user the related items and how to buy it.
@interface BVCurationsProductDetail : NSObject

    @property NSString *productKey;
    @property NSString *productId;
    @property NSString *productImageUrl;
    @property NSString *productName;
    @property NSString *productPageUrl;
    @property NSString *productDescription;
    @property NSNumber *totalReviewCount; // int
    @property NSNumber *avgRating; // float

    -(id)initWithDict:(NSDictionary*)dict withKey:(NSString *)key;

@end
