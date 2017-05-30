//
//  BVBaseUGCSubmission.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"

@implementation BVBaseUGCSubmission

- (nonnull instancetype)init {
    
    self = [super init];
    if (self){
         self.photos = [NSMutableArray array];
    }
    
    return self;
    
}

-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption {
    BVUploadablePhoto* photo = [[BVUploadablePhoto alloc] initWithPhoto:image photoCaption:photoCaption];
    [self.photos addObject:photo];
}

@end
