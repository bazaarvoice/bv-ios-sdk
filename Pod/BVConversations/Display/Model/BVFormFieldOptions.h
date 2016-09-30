//
//  BVFormFieldOptions.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface BVFormFieldOptions : NSObject

@property NSString* _Nonnull label;
@property NSString* _Nonnull value;
@property NSNumber* _Nonnull selected; // Boolean

- (id _Nonnull)initWithOptionsDictionary:(NSDictionary * _Nonnull)dictionary;

@end
