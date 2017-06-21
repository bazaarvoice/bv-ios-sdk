//
//  BVUploadableYouTubeVideo.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVUploadableYouTubeVideo : NSObject

-(nonnull instancetype)initWithVideoURL:(nonnull NSString*)url videoCaption:(nullable NSString*)caption;

@property (readonly) NSString* _Nonnull videoURL;
@property (readonly) NSString* _Nullable videoCaption;

@end
