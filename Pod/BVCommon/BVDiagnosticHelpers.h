//
//  NSBundle+DiagnosticInformation.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVDiagnosticHelpers : NSObject

+(NSString*)releaseVersionNumber;
+(NSString*)buildVersionNumber;

@end
