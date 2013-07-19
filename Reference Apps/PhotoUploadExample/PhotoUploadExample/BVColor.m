//
//  BVColor.m
//  PhotoUploadExample
//
//  Created by Bazaarvoice Engineering on 5/8/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//

#import "BVColor.h"

@implementation BVColor

+ (UIColor *)primaryBrandColor
{
    return [UIColor colorWithRed:0/255.0 green:60/255.0 blue:78/255.0 alpha:1];
}

+ (UIColor *)secondaryBrandColor
{
    return [UIColor colorWithRed:0/255.0 green:171/255.0 blue:142/255.0 alpha:1]; 
}

+ (UIColor *)formElementColor
{
    return [UIColor colorWithRed:100/255.0 green:119/255.0 blue:145/255.0 alpha:1]; 
}

+ (UIColor *)appBackgroundColor
{
    return [UIColor colorWithRed:127/255.0 green:157/255.0 blue:165/255.0 alpha:1]; 
}

+ (UIColor *)secondaryTextBoxColor
{
    return [UIColor colorWithRed:225/255.0 green:239/255.0 blue:239/255.0 alpha:1]; 
}

+ (UIColor *)textColor
{
    return [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1]; 
}

+ (UIColor *)linkColor
{
    return [UIColor colorWithRed:231/255.0 green:145/255.0 blue:73/255.0 alpha:1]; 
}

+ (UIColor *)inlineLinkColor
{
    return [UIColor colorWithRed:153/255.0 green:64/255.0 blue:117/255.0 alpha:1]; 
}


@end
