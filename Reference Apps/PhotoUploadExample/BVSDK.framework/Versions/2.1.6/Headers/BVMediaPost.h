//
//  BVMediaPost.h
//  BazaarvoiceSDK
//
//  BVMediaPost is used for all requests to the Bazaarvoice
//  API which require a binary multipart post.  This includes
//  submitting photos and videos.
//
//  Created by Bazaarvoice Engineering on 11/29/12.
//
//  Copyright 2013 Bazaarvoice, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BVConstants.h"
#import "BVDelegate.h"
/*!
 BVMediaPost is used for all requests to the Bazaarvoice API which require a binary multipart post.  This includes submitting photos and videos. 
 
 In the simplest case, a request might be created as follows:
 
 BVMediaPost *photoSubmission = [[ BVMediaPost alloc ] initWithType:BVMediaPostTypePhoto ]; <br />
 photoSubmission.contentType = BVMediaPostContentTypeReview; <br />
 mySubmission.userId = @"123"; <br />
 mySubmission.photo = <my_UIImage>; <br />
 [ mySubmission sendRequestWithDelegate:self ]; <br />

 The specified delegate will then receive BVDelegate callbacks when a response is received.  Note that it is the client's responsibility to set the delegate to nil in the case that the the delegate is deallocated before a response is received.
 */
@interface BVMediaPost : NSObject
/*!
 Convenience initializer with type.
 @param type The particular type (BVMediaPostTypePhoto or BVMediaPostTypeVideo) of this request.
 */
- (id)initWithType:(BVMediaPostType)type;
/*
 The particular type (BVMediaPostTypePhoto or BVMediaPostTypeVideo) of this request.
 */
@property (assign, nonatomic) BVMediaPostType type;
/*!
 The client delegate to receive BVDelegate notifications.
 */
@property (weak) id<BVDelegate> delegate;
/*!
 The URL that this request was sent to.  Is only available after the request has been sent.
 */
@property (readonly) NSString *requestURL;
/*!
 The content type for which this media is being submitted. Review, question, answer or story.
 */
@property (assign, nonatomic) BVMediaPostContentType contentType;
/*!
Locale to display Labels, Configuration, Product Attributes and Category Attributes in. The default value is the locale defined in the display associated with the API key.
*/
@property (assign, nonatomic) NSString * locale;
/*!
 User's external ID.
 */
@property (assign, nonatomic) NSString * userId;
/*!
 A UIImage to be submitted.
 */
@property (assign, nonatomic) UIImage * photo;
/*!
 URL of the photo to be uploaded. Use either the photo or photoUrl parameter to define the photo to upload. An error is returned if both parameters are defined. HTTP and HTTPS are the only protocols supported for the photoUrl parameter.
 */
@property (assign, nonatomic) NSString * photoUrl;


/*!
 A video to be submitted.
 @param video NSData representing a video file to be uploaded.  
 @param format Format of the video file to be uploaded.  This file may be of any of the valid format types defined by BVVideoFormatType.
 */
- (void)setVideo:(NSData *)video withFormat:(BVVideoFormatType)format;

/*!
 A video file to be submitted.
 @param file NSURL representing a video file on disk to be uploaded.
 @param format Format of the video file to be uploaded.  This file may be of any of the valid format types defined by BVVideoFormatType.
 */
- (void)setVideoFile:(NSURL *)file withFormat:(BVVideoFormatType)format;


/*!
 Adds a generic parameter to the request.  This method should be used as a last resort when another method does not exist for a particular request you would like to make.  Behavior may be undefined.
 @param name of parameter.
 @param value of parameter.
 */
- (void)addGenericParameterWithName:(NSString *)name value:(NSString *)value;

/*!
 Returns the string representation of the video file set by setVideo:withFormat:
 */
- (NSString *)getVideoExtensionString;

/*!
 Sends request asynchronously.  A delegate must be set before this method is called.
 */
- (void) send;
/*!
 Convenience method to set delegate and send request asynchronously.
 @param delegate  The client delegate to receive BVDelegate notifications.
 */
- (void) sendRequestWithDelegate:(id<BVDelegate>)delegate;

@end
