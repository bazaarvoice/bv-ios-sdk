//
//  BVMessageInterceptor.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVMessageInterceptor : NSObject

@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;

-(id)initWithMiddleman:(id)middleMan;

@end
