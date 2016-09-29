//
//  BVNullHelper.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVNullHelper_h
#define BVNullHelper_h

#define SET_IF_NOT_NULL(target, value) if(value != [NSNull null]) { target = value; }

static inline bool isObjectNilOrNull(NSObject *object){

    if (object == nil || object == [NSNull null]){
        return true;
    } else {
        return false;
    }
}

#endif /* BVNullHelper_h */
