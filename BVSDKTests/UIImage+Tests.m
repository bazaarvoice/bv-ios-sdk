//
//  UIImage+Tests.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "UIImage+Tests.h"

@implementation UIImage (Tests)
+(UIImage*)testImageNamed:(NSString*) imageName
{
    NSBundle *bundle = [NSBundle bundleForClass:[BundleLocator class]];
    NSString *imagePath = [bundle pathForResource:imageName.stringByDeletingPathExtension ofType:imageName.pathExtension];
    return [UIImage imageWithContentsOfFile:imagePath];
}
@end

@implementation BundleLocator
@end
