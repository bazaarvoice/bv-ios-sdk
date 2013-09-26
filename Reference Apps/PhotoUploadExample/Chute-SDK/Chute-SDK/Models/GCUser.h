//
//  GCUser.h
//  GetChute
//
//  Created by Aleksandar Trpeski on 2/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCLinks;

@interface GCUser : NSObject

@property (strong, nonatomic) NSNumber  *id;
@property (strong, nonatomic) GCLinks   *self;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *username;
@property (strong, nonatomic) NSString  *avatar;

@end
