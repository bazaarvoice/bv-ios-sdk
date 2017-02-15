//
//  BVCurationsFeedRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "BVCurations.h"

/*!
 Use the BVCurationsFeedRequest object to construct query parameters used by the BVGetCurationsFeed API request.
 */
@interface BVCurationsFeedRequest : NSObject


/*!
    Initialize the parameters with the always required groups parameter
 
    @param groups Array of NSStrings
 */
- (id)initWithGroups:(NSArray<NSString *>*)groups;


/// Unavailable, use the designated initializer.
- (instancetype)init __attribute__((unavailable("Use -initWithGroups: instead")));


/// Creates an array of NSURLQueryItem item objects for use in querying the Curations feed API.
- (NSArray *)createQueryItems;


/// The administered groups which you want to query. This parameter is required. The values in the groups are configured in the Curations management console.
@property NSArray< NSString* >* groups;


/// Set the user's current location, to tailor the content to their location.
- (void)setLatitude:(double)latitude longitude:(double)longitude;


/// Sending a UNIX timestamp for after returns content posted only on or after that time.
@property NSNumber* after;


/// Sending a UNIX timestamp for before returns content posted only on or before that time.
@property NSNumber* before;



/// Sending a value for author returns updates that match only that author. If this is set, Bazaarvoice will perform a lookup against either the token or alias of the author. Any author that matches either one is considered a match.
@property NSString* author;


/*!
    Sending a number for featured requires at least that many featured updates to come down in your feed. These featured updates count against the overall limit specified in limit. For example, setting limit to 25 and featured to 10 returns 10 featured updates and 15 other updates, which may be featured or non-featured).
 
    If you specify a number greater than the number of featured updates that you have in the feed, Bazaarvoice sends all the featured updates and counts that number against the total limit. Continuing the prior example, if you only have 7 featured updates in your feed, you'd get the 7 featured updates and then 18 non-featured updates.)
 */
@property NSUInteger featured;


/*!
    Setting has_geotag causes the feed to be filtered based on the presence or absence of a geotag on the update. Set this to true to require a geotag or false to require the absence of one.
 
    Note that setting one or more has_geotag, has_link, has_photo, or has_video parameters yields the intersection (not the union) of the selected filters.
 */
@property NSNumber* hasGeotag;


/*!
    Setting has_link causes the feed to be filtered based on the presence or absence of a link on the update. Set this to true to require a link or false to require the absence of one.
 
    Note that setting one or more has_geotag, has_link, has_photo, or has_video parameters yields the intersection (not the union) of the selected filters.
 */
@property NSNumber* hasLink;


/// Setting has_photo causes the feed to be filtered based on the presence or absence of a photo on the update. Set this to true to require a photo or false to require the absence of one.
///
/// Note that setting one or more has_geotag, has_link, has_photo, or has_video parameters yields the intersection (not the union) of the selected filters.
@property NSNumber* hasPhoto;


/// Setting has_video causes the feed to be filtered based on the presence or absence of a video on the update. Set this to true to require a video or false to require the absence of one.
///
///    Note that setting one or more has_geotag, has_link, has_photo, or has_video parameters yields the intersection (not the union) of the selected filters.
@property NSNumber* hasVideo;

/// Setting hasPhotoOrVideo causes the feed to be filtered based on the presence or absence of a photo or video on the update. Set this to true to require a video or false to require the absence of one.
///
///    Note that setting one or more hasPhotoOrVideo, has_geotag, has_link, has_photo, or has_video parameters yields the intersection (not the union) of the selected filters.
@property NSNumber* hasPhotoOrVideo;


/// On some channels, Bazaarvoice sends comments about an update along with the update. This option controls whether comments are included in your feed. Be aware that including comments, especially in feeds where they are common, can drastically increase output size and reduce performance. Also, Bazaarvoice does not poll for comments indefinitely. When an update reaches a certain age, its comments are no longer updated.
@property NSNumber* includeComments;


/// This is the number of updates Bazaarvoice sends. You can request any number between 0 and 100. If you ask for more updates than exist in the feed, Bazaarvoice sends what is available. Asking for a large number of updates does not guarantee you will get that many updates.
@property NSUInteger limit;


/// Sending the media property overrides default sizes for images and videos. Send media as a nested dictionary-like object. Keys should be the type of media, most often photo or video, although a few other keys such as icon will work. The values should be dictionaries themselves, with width and height keys, the values of which can be ints or strings. For example: {'video': {'width': 480, 'height': 360}}.
@property NSDictionary* media;


/// String Array where each element is a string representing a tag. Setting this causes the system to return only updates with at least one of the tags in the tag array.
/// If you want to include only one tag in your feed, you can send this as a string instead of an array with a single value, but either will work.
@property NSArray* tags;



///    The external product id used for syndication.
///    Setting externalId returns both client content and syndicated content. If externalId is not valid, only client content will be returned.
@property NSString* externalId;


/// Setting to true to include product data tagged in the Curations feed. May not be availale for all feeds.
@property NSNumber* withProductData;

@end
