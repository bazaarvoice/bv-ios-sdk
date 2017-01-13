//
//  NSBundle+DiagnosticInformation.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDiagnosticHelpers.h"

@implementation BVDiagnosticHelpers

+(NSString*)releaseVersionNumber {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(NSString*)buildVersionNumber {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
