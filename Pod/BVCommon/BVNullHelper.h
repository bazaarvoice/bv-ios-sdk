//
//  BVNullHelper.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVNullHelper_h
#define BVNullHelper_h

#define SET_IF_NOT_NULL(target, value) if(value != [NSNull null]) { target = value; }

#endif /* BVNullHelper_h */
