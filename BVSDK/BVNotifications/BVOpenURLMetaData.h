//
//  BVOpenUrlMetaData.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

typedef enum { BVSenderTypeNotification } BVSenderType;

typedef enum { BVContentTypeReview } BVContentType;

typedef enum {
  BVContentSubtypeStore,
  BVContentSubtypeProduct
} BVContentSubtype;

@interface BVOpenURLMetaData : NSObject

- (instancetype)initWithURL:(NSURL *)url;

@property(nonatomic, assign, readonly) BVSenderType sender;
@property(nonatomic, assign, readonly) BVContentType type;
@property(nonatomic, assign, readonly) BVContentSubtype subtype;
@property(nonatomic, strong, readonly) NSString *ID;

@end
