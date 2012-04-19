//
//  BVSettings.h
//  bazaarvoiceSDK
//  
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//

/*
 
 BVSettings is a singleton object contained in all the BVDisplay to set the login credentials
 
*/

#import <Foundation/Foundation.h>
#define BAZAARVOICECOM @"bazaarvoice.com"

@interface BVSettings : NSObject {
    
}

+ (BVSettings*) instance;

@property (nonatomic, copy) NSString* passKey;
@property (nonatomic, copy) NSString* apiVersion;
@property (nonatomic, copy) NSString* customerName;
@property (nonatomic, copy) NSString* dataString;
@property (nonatomic, copy) NSString* formatString;

@end