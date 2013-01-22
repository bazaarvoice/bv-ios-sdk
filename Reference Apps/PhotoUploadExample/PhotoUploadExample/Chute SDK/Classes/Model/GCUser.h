//
//  GCUser.h
//
//  Created by Achal Aggarwal on 07/09/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCResource.h"

@interface GCUser : GCResource

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *avatarURL;

@end
