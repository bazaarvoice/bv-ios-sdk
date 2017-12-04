//
//  BVSubmissionAction.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The two allowable submission actions - Submit and Preview.
 `action == submit` actually tries to submit the content.
 `action == preview` doesn't try to submit the content, only validates the
 content and returns with success or any errors that may occur during
 validation.
 */
typedef NS_ENUM(NSInteger, BVSubmissionAction) {
  BVSubmissionActionSubmit,
  BVSubmissionActionPreview
};

@interface BVSubmissionActionUtil : NSObject

+ (nonnull NSString *)toString:(BVSubmissionAction)action;

@end
