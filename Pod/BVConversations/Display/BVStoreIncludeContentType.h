//
//  BVStoreIncludeContentType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Types of Bazaarvoice content.
 */
typedef NS_ENUM(NSInteger, BVStoreIncludeContentType) {
    BVStoreIncludeContentTypeReviews
};

@interface BVStoreIncludeContentTypeUtil : NSObject

+(NSString*)toString:(BVStoreIncludeContentType)type;

@end
