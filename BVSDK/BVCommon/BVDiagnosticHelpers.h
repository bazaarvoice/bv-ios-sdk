//
//  NSBundle+DiagnosticInformation.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVDiagnosticHelpers : NSObject

+ (NSString *)releaseVersionNumber;
+ (NSString *)buildVersionNumber;

@end
