//
//  BVOpenUrlMetaData.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVOpenURLMetaData.h"
#import "BVProductReviewNotificationConfigurationLoader.h"

@implementation BVOpenURLMetaData

-(instancetype)initWithURL:(NSURL*)url {
    
    if (![url.scheme isEqualToString:[[[BVProductReviewNotificationConfigurationLoader sharedManager] bvProductReviewNotificationProperties] customUrlScheme]]) {
        return nil;
    }
    
    if (self = [super init]) {
        NSArray *queries = [url.query componentsSeparatedByString:@"&"];
        for (NSString *query in queries) {
            NSArray *comps = [query componentsSeparatedByString:@"="];
            if ([@"sender" isEqualToString:comps[0]]) {
                if ([@"notification" isEqualToString:comps[1]]) {
                    _sender = BVSenderTypeNotification;
                }
            }else if ([@"type" isEqualToString:comps[0]]) {
                if ([@"review" isEqualToString:comps[1]]) {
                    _type = BVContentTypeReview;
                }
            }else if ([@"subtype" isEqualToString:comps[0]]) {
                if ([@"store" isEqualToString:comps[1]]) {
                    _subtype = BVContentSubtypeStore;
                }else if ([@"product" isEqualToString:comps[1]]) {
                    _subtype = BVContentSubtypeProduct;
                }
            }else if ([@"id" isEqualToString:comps[0]]) {
                _ID = comps[1];
            }
        }
    }
    return self;
}

@end
