//
//  BVNullHelper.h
//  Bazaarvoice SDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#ifndef BVNullHelper_h
#define BVNullHelper_h

#define SET_IF_NOT_NULL(target, value) if(value != [NSNull null]) { target = value; }
#define SET_DEFAULT_IF_NULL(target, value, default) if(value && value != [NSNull null]) target = value; else target = default;

static inline bool isObjectNilOrNull(NSObject *object){

    if (object == nil || object == [NSNull null]){
        return true;
    } else {
        return false;
    }
}

#endif /* BVNullHelper_h */
