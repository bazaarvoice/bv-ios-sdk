//
//  BVPixel.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVPixel.h"
#import "BVAnalyticsManager.h"
#import <AdSupport/AdSupport.h>

@implementation BVPixel
static NSSet* whitelistParams;

+(void)initialize{
    sranddev();
    //these are considered the only non-PII params
    whitelistParams= [[NSSet alloc]initWithObjects: @"orderId", @"affiliation", @"total",
                                                @"tax", @"shipping", @"city",
                                                @"state", @"country", @"currency",
                                                @"items", @"locale", @"type",
                                                @"label", @"value", @"proxy",
                                                @"partnerSource", @"TestCase", @"TestSession",
                                                @"dc",@"ref",nil];
}

+(void)trackConversionTransaction:(BVTransaction*)transaction{
    
    NSMutableDictionary *allParams = [self buildBasicConversion];
    [allParams setObject:transaction.orderId forKey:@"orderId"];
    [allParams setObject:[NSString stringWithFormat:@"%0.2f", transaction.total] forKey:@"total"];
    [allParams setObject:@"Transaction" forKey:@"type"];
    
    if (transaction.tax){
        [allParams setObject:[NSString stringWithFormat:@"%0.2f", transaction.tax] forKey:@"tax"];
    }
    
    if (transaction.shipping){
        [allParams setObject:[NSString stringWithFormat:@"%0.2f", transaction.shipping] forKey:@"shipping"];
    }
    
    if (transaction.city){
        [allParams setObject:transaction.city forKey:@"city"];
    }

    if (transaction.state){
        [allParams setObject:transaction.state forKey:@"state"];
    }
    
    if (transaction.country){
        [allParams setObject:transaction.country forKey:@"country"];
    }
    
    if (transaction.currency){
        [allParams setObject:transaction.city forKey:@"currency"];
    }
    
    NSMutableArray *serializedItems = [NSMutableArray new];
    
    for(BVTransactionItem* item in transaction.items){
        
        NSMutableDictionary *itemParams = [NSMutableDictionary new];
        [itemParams setObject:item.sku forKey:@"sku"];
        if (item.name) {
            [itemParams setObject:item.name forKey:@"name"];
        }
        
        if (item.imageUrl) {
            [itemParams setObject:item.imageUrl forKey:@"imageUrl"];
        }
        
        if (item.category) {
            [itemParams setObject:item.category forKey:@"category"];
        }
        
        [itemParams setObject:[NSString stringWithFormat:@"%d", item.quantity] forKey:@"quantity"];
        [itemParams setObject:[NSString stringWithFormat:@"%0.2f", item.price] forKey:@"price"];
        [serializedItems addObject:itemParams];
    }
    [allParams setObject:serializedItems forKey:@"items"];
    
    [self separatePIIAndQueueEvents:allParams otherParams:[transaction.otherParams mutableCopy]];
   }

+(void)trackNonCommerceConversion:(BVConversion* _Nonnull)conversion{
    NSAssert(conversion.type, @"You must provide a type");
    NSAssert(conversion.value, @"You must provide a value");
    
    NSMutableDictionary *allParams = [self buildBasicConversion];

    [allParams setObject:conversion.type forKey:@"type"];
    [allParams setObject:conversion.value forKey:@"value"];
    if (conversion.label){
        [allParams setObject:conversion.label forKey:@"label"];
    }

    [self separatePIIAndQueueEvents:allParams otherParams:[conversion.otherParams mutableCopy]];
}

+(NSMutableDictionary*)buildBasicConversion{
    NSMutableDictionary *allParams = [NSMutableDictionary new];
    [allParams setObject:@"Conversion" forKey:@"cl"];
    [allParams setObject:@"native-mobile-sdk" forKey:@"source"];
    [allParams setObject:[self getLoadId] forKey:@"loadId"];
    return allParams;
}

+(NSDictionary*)getNonPII:(NSMutableDictionary* _Nullable)params{
    NSMutableDictionary *nonPIIParmas = [NSMutableDictionary new];

    if(params){
        for (NSString *key in params.allKeys){
            if ([whitelistParams containsObject:key]){
                [nonPIIParmas setObject:params[key] forKey:key];
            }
        }
    }
    return nonPIIParmas;
}

+(void)separatePIIAndQueueEvents:(NSMutableDictionary*)baseEvent otherParams:(NSMutableDictionary* _Nullable)params{
    NSMutableDictionary *nonPIIParmas = [NSMutableDictionary dictionaryWithDictionary:baseEvent];
    
    BOOL hadPII = NO;
    if(params){
        [baseEvent addEntriesFromDictionary:params];
        NSDictionary *nonPII = [self getNonPII:params];
        [nonPIIParmas addEntriesFromDictionary:nonPII];
        hadPII = params.count != nonPII.count;
    }
    
    //no pii send one with all params w/o idfa
    //pii send two. 1 with pii w/o idfa and 1 w/o pii with(out) idfa
    
    if(hadPII){
        [baseEvent setObject:@"PIIConversion" forKey:@"cl"];
        [baseEvent setObject:@"true" forKey:@"hadPII"];
        [nonPIIParmas setObject:@"true" forKey:@"hadPII"];
  
        [[BVAnalyticsManager sharedManager] queueAnonymousEvent:baseEvent];
        [[BVAnalyticsManager sharedManager] queueEvent:nonPIIParmas];
    }else{
        [[BVAnalyticsManager sharedManager] queueEvent:nonPIIParmas];
    }

}

+(NSString*)getLoadId{
    int charLimit = 20;
    NSMutableString* loadId = [NSMutableString new];
    
    while (loadId.length < charLimit) {
        [loadId appendFormat:@"%x", rand() % 16];
    }
    
    return loadId;
}

@end
