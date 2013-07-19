//
//  BVColor.h
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 5/8/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//
//  Static class for accessing colors used throughout the application.

#import <Foundation/Foundation.h>

@interface BVColor : NSObject
+ (UIColor *)primaryBrandColor;
+ (UIColor *)secondaryBrandColor;
+ (UIColor *)formElementColor;
+ (UIColor *)appBackgroundColor;
+ (UIColor *)secondaryTextBoxColor;
+ (UIColor *)textColor;
+ (UIColor *)linkColor;
+ (UIColor *)inlineLinkColor;
@end
