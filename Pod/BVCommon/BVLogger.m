//
//  BVLogger.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVLogger.h"

#define BV_LOG_TAG @"<bazaarvoice>"

@implementation BVLogger

static BVLogger *sharedLoggerInstance = nil;

+ (BVLogger *) sharedLogger {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLoggerInstance = [[self alloc] init];
    });
    
    return sharedLoggerInstance;
}

-(id)init {
    self = [super init];
    if(self){
        self.logLevel = BVLogLevelError;
    }
    return self;
}

-(void)verbose:(NSString*)message {
    [self printMessage:message forLogLevel:BVLogLevelVerbose];
}

-(void)info:(NSString*)message {
    [self printMessage:message forLogLevel:BVLogLevelInfo];
}

-(void)warning:(NSString*)message {
    [self printMessage:message forLogLevel:BVLogLevelWarning];
}

-(void)error:(NSString*)message {
    [self printMessage:message forLogLevel:BVLogLevelError];
}

-(void)printMessage:(NSString*)message forLogLevel:(BVLogLevel)logLevel {
    if(self.logLevel >= logLevel){
        NSLog(@"%@: %@", BV_LOG_TAG, message);
    }
}

@end
