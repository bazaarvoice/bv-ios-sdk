//
//  Include.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDPContentType.h"

/// Internal class - used only within BVSDK
@interface PDPInclude : NSObject

@property PDPContentType type;
@property NSNumber* _Nullable limit;

-(id _Nonnull)initWithContentType:(PDPContentType)type limit:(NSNumber* _Nullable)limit;
-(NSString* _Nonnull)toParamString;

@end
