//
//  UIImage+Tests.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (BundleLocator)
+(UIImage*)bundledImageNamed:(NSString*) imageName;
@end

@interface BundleLocator : NSObject
@end
