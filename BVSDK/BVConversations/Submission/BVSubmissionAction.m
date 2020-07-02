//
//  BVSubmissionAction.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionAction.h"

@implementation BVSubmissionActionUtil

+ (nonnull NSString *)toString:(BVSubmissionAction)action {

  switch (action) {

  case BVSubmissionActionSubmit:
    return @"Submit";
  case BVSubmissionActionPreview:
    return @"Preview";
  case BVSubmissionActionForm:
    return @"";
  }
}

@end
