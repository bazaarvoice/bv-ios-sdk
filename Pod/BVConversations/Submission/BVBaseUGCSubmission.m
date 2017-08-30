//
//  BVBaseUGCSubmission.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"
#import "BVFormField.h"
#import "BVFormFieldOptions.h"

@implementation BVBaseUGCSubmission

- (nonnull instancetype)init {
    
    self = [super init];
    if (self){
        self.photos = [NSMutableArray array];
        self.customFormPairs = [NSMutableArray array];
    }
    
    return self;
    
}

-(void)addPhoto:(nonnull UIImage*)image withPhotoCaption:(nullable NSString*)photoCaption {
    BVUploadablePhoto* photo = [[BVUploadablePhoto alloc] initWithPhoto:image photoCaption:photoCaption];
    [self.photos addObject:photo];
}

-(void)addCustomSubmissionParameter:(nonnull NSString*)parameter withValue:(nonnull NSString *)value {
    BVStringKeyValuePair* customFormPair = [BVStringKeyValuePair pairWithKey:parameter value:value];
    [self.customFormPairs addObject:customFormPair];
}

@end
