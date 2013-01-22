//
//  GCInvite.h
//  chute
//
//  Created by Brandon Coston on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetChute.h"

@interface GCInvite : GCResource{
    
}

-(GCChute*)chute;
-(GCUser*)invited_by;

-(BOOL)accept;
-(void)acceptInBackgroundWithResponseBlock:(GCBoolBlock)boolBlock;
-(BOOL)decline;
-(void)declineInBackgroundWithResponseBlock:(GCBoolBlock)boolBlock;

@end
