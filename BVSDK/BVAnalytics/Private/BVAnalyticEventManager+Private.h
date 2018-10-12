//
//  BVAnalyticEventManager+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVANALYTICEVENTMANAGER_PRIVATE_H
#define BVANALYTICEVENTMANAGER_PRIVATE_H

#import "BVAnalyticEventManager.h"

@interface BVAnalyticEventManager ()

@property(strong, nonatomic) NSString *eventSource;

- (NSDictionary *)getCommonAnalyticsDictAnonymous:(BOOL)anonymous;

@end

#endif /* BVANALYTICEVENTMANAGER_PRIVATE_H */
