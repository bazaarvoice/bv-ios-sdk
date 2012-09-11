//
//  BVSettings.h
//  bazaarvoiceSDK
//  
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

/*!
 BVSettings is a singleton object which contains credentials common to all API requests.
 
 By default, all BV requests use this object by calling the [BVSettings instance] method.  This default can be overridden via the BVBase settingsObject property. 
 */
@interface BVSettings : NSObject {
    
}

/*! 
 Static accessor method
 */
+ (BVSettings*) instance;

/*!
 This is the passkey assigned to the customer. The default value is set to a passkey that works with the test server.
 */
@property (nonatomic, copy) NSString* passKey;
/*!
 The API version used. The default is set to 5.1
 */
@property (nonatomic, copy) NSString* apiVersion;
/*!
 The customer name used in the request. Default is set to reviews.apitestcustomer.bazaarvoice.com
 */
@property (nonatomic, copy) NSString* customerName;
/*!
 The URL immediately after bazaarvoice.com/. The default is set to
 bvstaging/data used by the test server.
 */
@property (nonatomic, copy) NSString* dataString;
/*!
 At this point, this should always be left to the default setting “JSON”. If XML parsing
 is implemented at a later date, this should be set to “XML”.
 */
@property (nonatomic, copy) NSString* formatString;

@end