//
//  ContextDataValue.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A Bazaarvoice Context Data Value. Generally, this is extra information collected when a user
 submitted a review, question, or answer.
 A common Context Data Value is "Age" and "Gender". 
 */
@interface BVContextDataValue : NSObject

@property NSString* _Nullable value;
@property NSString* _Nullable valueLabel;
@property NSString* _Nullable dimensionLabel;
@property NSString* _Nullable identifier;

-(id _Nonnull)initWithApiResponse:(id _Nonnull)apiResponse;

@end