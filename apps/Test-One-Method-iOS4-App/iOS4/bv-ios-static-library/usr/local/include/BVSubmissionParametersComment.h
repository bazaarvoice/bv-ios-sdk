//
//  BVSubmissionParametersComment.h
//  bazaarvoiceSDK
//
//  Created by Leon Fu on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BVSubmissionParametersBase.h"

@interface BVSubmissionParametersComment : BVSubmissionParametersBase

@property (nonatomic, copy) NSString* commentText;
@property (nonatomic, copy) NSString* reviewId;
@property (nonatomic, copy) NSString* storyId;
@property (nonatomic, copy) NSString* title;

@end