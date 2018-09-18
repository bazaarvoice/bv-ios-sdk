//
//  BVCurationsAddPostRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsFeedItem.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

__attribute__ ((deprecated))
@interface BVCurationsAddPostRequest : NSObject

/*!
 Initialize the parameters with the always required groups parameter

 @param groups Array of NSStrings that specifies which Curations group or groups
 to post to.
 @param alias The author's alias
 @param token  Unique identifier for this author/alias
 @param text The user's comment for this post object

 @return Fully initialized BVCurationsAddPostParams with the minimum required
 parameters.

 */
- (nonnull id)initWithGroups:(nonnull NSArray<NSString *> *)groups
             withAuthorAlias:(nonnull NSString *)alias
                   withToken:(nonnull NSString *)token
                    withText:(nonnull NSString *)text;

/*!
 Initialize the parameters with the always required groups parameter

 @param groups Array of NSStrings that specifies which Curations group or groups
 to post to.
 @param alias The author's alias
 @param token  Unique identifier for this author/alias
 @param text The user's comment for this post object
 @param image The UIImage supplied by the user for upload

 @return Fully initialized BVCurationsAddPostParams with the minimum required
 parameters.

 */
- (nonnull id)initWithGroups:(nonnull NSArray<NSString *> *)groups
             withAuthorAlias:(nonnull NSString *)alias
                   withToken:(nonnull NSString *)token
                    withText:(nonnull NSString *)text
                   withImage:(nonnull UIImage *)image;

/*!
 *  Unavailable, use the designated initializer.
 *
 *  @return nil
 */
- (nonnull instancetype)init
    __attribute__((unavailable("Use -initWithGroups: instead")));

/*!
  JSON Serialize all parameters set on this object.
 */
- (nonnull NSData *)serializeParameters;

///////////////////////
// Readonly parameters
///////////////////////

/*!Array of NSStrings that specifies which Curations group or groups to post to.
 * Set this with the designated initializer. */
@property(nonnull, readonly) NSArray<NSString *> *groups;

/*! The author's alias. Set this with the designated initializer. */
@property(nonnull, readonly) NSString *alias;

/*! The user's comment for this post object. Set this with the designated
 * initializer. */
@property(nonnull, readonly) NSString *token;

/////////////////////////////////////////
// Optional parameters that can be set
/////////////////////////////////////////

/*! User's comment on the post. Set this with the designated initializer. */
@property(nonnull) NSString *text;

/*! The URL string to an avatar for the author. */
@property(nonnull) NSString *authorAvatarURL;

/*! The URL to a profile page for the author. */
@property(nonnull) NSString *authorProfileURL;

/*! A list of tags, with each tag specified as a string, to be added to the
 * post. Example: @["ffiv", "cecil"] */
@property(nonnull) NSArray<NSString *> *tags;

/*! The URL to a permalink correspoding with this update. */
@property(nonnull) NSString *permalink;

/*! A human readable place, such as "Austin, TX" or "Mysidia". */
@property(nonnull) NSString *place;

/*!  A longer block of teaser text, such as we send down for articles. */
@property(nonnull) NSString *teaser;

/*! The Unix timestamp for then this update was considered to be created. If you
 * don't send this, we'll use the time that it was added to our system as the
 * default. */
@property double unixTimeStamp;

/*! The longitude attributed to the post. */
@property double longitude;

/*! The latitude attributed to the post. */
@property double latitude;

/*! The UIImage asset to be uploaded to Curations */
@property(nonnull) UIImage *image;

/*! Attach URL strings for links for custom udpates. These links will be
 * attached to the post. */
@property(nonnull) NSArray<NSString *> *links;

/*! Attach URLs to photos for custom udpates. These images displayed from the
 * fully-qualified URLs will be displayed in the post. When this option is used,
 * the 'image' value will be ignored. */
@property(nonnull) NSArray<NSString *> *photos;

@end
