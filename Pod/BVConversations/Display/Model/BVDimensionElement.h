//
//  DimensionElement.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A single tag dimension. 
 */
@interface BVDimensionElement : NSObject

@property NSString* _Nullable label;
@property NSString* _Nullable identifier;
@property NSArray<NSString*>* _Nullable values;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

@end
