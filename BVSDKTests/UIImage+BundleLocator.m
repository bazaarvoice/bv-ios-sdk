//
//  UIImage+Tests.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "UIImage+BundleLocator.h"

@implementation UIImage (BundleLocator)
+ (UIImage *)bundledImageNamed:(NSString *)imageName {

  return [UIImage imageNamed:imageName
                           inBundle:[NSBundle
                                        bundleForClass:[BundleLocator class]]
      compatibleWithTraitCollection:nil];
}
@end

@implementation BundleLocator
@end
