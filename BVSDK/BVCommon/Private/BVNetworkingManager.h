//
//  BVNetworkingManager.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Private interface for internal BV networking management. Since there's
 * various vagaries associated with sending/receiving networking data we're
 * going to try and shove all of that here to try and abstract it away from the
 * various other objects that need to interact with BV APIs.
 */
@interface BVNetworkingManager : NSObject

/// Create and get the singleton instance of the networking manager.
+ (nonnull instancetype)sharedManager;

/// Right now this will only vend the global context URLSession used internally,
/// however, just in case we have context specific networking requests we can
/// shoehorn this into this class eventually.
@property(nonnull, readonly) NSURLSession *bvNetworkingSession;

@end
