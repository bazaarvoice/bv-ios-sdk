//
//  ContextDataValue.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A Bazaarvoice Context Data Value. Generally, this is extra information
 collected when a user
 submitted a review, question, or answer.
 A common Context Data Value is "Age" and "Gender".
 */
@interface BVContextDataValue : NSObject

@property(nullable) NSString *value;
@property(nullable) NSString *valueLabel;
@property(nullable) NSString *dimensionLabel;
@property(nullable) NSString *identifier;

- (nonnull id)initWithApiResponse:(nonnull id)apiResponse;

@end
