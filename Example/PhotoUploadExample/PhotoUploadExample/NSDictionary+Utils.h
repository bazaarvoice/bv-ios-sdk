//
//  NSDictionary+Utils.h
//  Bazaarvoice SDK - Photo Upload Example Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//
//
//  This category allows for graceful handling of null values in an
//  NSDictionary when parsing JSON.  For example:
// 
//  UITextLabel *myLabel.text = [myDictionary objectForKey:@"nullKey"];
//
//  will crash, whereas:
//
//  UITextLabel *myLabel.text = [myDictionary objectForKeyNotNull:@"nullKey"];
//
//  will display nothing.


#import <UIKit/UIKit.h>

@interface NSDictionary (Utils)
- (id)objectForKeyNotNull:(id)key;
@end
