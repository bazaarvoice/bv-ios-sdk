//
//  GCResource.h
//
//  Created by Achal Aggarwal on 26/08/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCRequest.h"

@class GCResponse;
@class GCUser;

@interface GCResource : NSObject {
    @protected
    NSMutableDictionary *_content;
}

@property (nonatomic, readonly) NSMutableDictionary *content;

//Initializing Methods
+ (id) objectWithDictionary:(NSDictionary *) dictionary;
- (id) initWithDictionary:(NSDictionary *) dictionary;

/* Get all Objects of this class */
+ (GCResponse *)all;
+ (void)allInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

//Find Specific object data with Id
+ (GCResponse *)findById:(NSString *) objectID;
+ (void)findById:(NSString *) objectID inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

//Find Specific object data with Shortcut
+ (GCResponse *)findByShortcut:(NSString*) objectID;
+ (void)findByShortcut:(NSString*) objectID inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

//Methods to Override in SubClass
+ (BOOL)supportsMetaData;
+ (NSString *)elementName;

- (void) setObject:(id) aObject forKey:(id)aKey;
- (id) objectForKey:(id)aKey;

//Common Meta Data Methods
+ (GCResponse *) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value;
+ (void) searchMetaDataForKey:(NSString *) key andValue:(NSString *) value inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (GCResponse *) getMetaData;
- (void) getMetaDataInBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (id) getMetaDataForKey:(NSString *) key;
- (void) getMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCResponseBlock) aResponseBlock;

- (BOOL) setMetaData:(NSDictionary *) metaData;
- (void) setMetaData:(NSDictionary *) metaData inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) setMetaData:(NSString *) data forKey:(NSString *) key;
- (void) setMetaData:(NSString *) data forKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) deleteMetaData;
- (void) deleteMetaDataInBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

- (BOOL) deleteMetaDataForKey:(NSString *) key;
- (void) deleteMetaDataForKey:(NSString *) key inBackgroundWithCompletion:(GCBoolBlock) aBoolBlock;

//Common Get Data Methods
- (GCUser *) user;
- (NSString *) objectID;
- (NSDate *) updatedAt;
- (NSDate *) createdAt;

//Instance Method Calls
- (GCResponse *) save;
- (void) saveInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolBlock;

- (GCResponse *) update;
- (void) updateInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolBlock;

- (GCResponse *) destroy;
- (void) destroyInBackgroundWithCompletion:(GCBoolErrorBlock) aBoolBlock;


@end
