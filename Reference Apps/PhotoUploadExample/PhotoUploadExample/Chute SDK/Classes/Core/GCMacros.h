//
//  GCMacros.h
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//
#ifndef ChuteMacros_h
#define ChuteMacros_h

//Comment this line to stop debug log on the debugger console.
//#define DEBUG

@class GCResponse;

typedef void(^GCBasicBlock)(void);
typedef void(^GCBoolBlock)(BOOL value);
typedef void(^GCBoolErrorBlock)(BOOL value, NSError *error);
typedef void(^GCErrorBlock)(NSError *error);
typedef void(^GCResponseBlock)(GCResponse *response);

#define kJSONResponse 1

#define DO_IN_BACKGROUND(action, responseBlock) \
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {\
        id _response = action;\
        dispatch_async(dispatch_get_main_queue(), ^(void) {\
            if (responseBlock) {\
                responseBlock(_response);\
            }\
        });\
    });

#define DO_IN_BACKGROUND_BOOL(action, responseBlock) \
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {\
        BOOL _response = action;\
        dispatch_async(dispatch_get_main_queue(), ^(void) {\
            if (responseBlock) {\
                responseBlock(_response);\
            }\
        });\
    });

#define DO_IN_BACKGROUND_BOOL_ERROR(action, responseBlock) \
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {\
        id _response = action;\
        dispatch_async(dispatch_get_main_queue(), ^(void) {\
            if (responseBlock) {\
                responseBlock([_response isSuccessful], [_response error]);\
            }\
        });\
    });

////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define IS_NULL(x)	((nil == x) || ([x isEqual: [NSNull null]]))

////////////////////////////////////////////////////////////////////////////////////////////////////////

#endif


