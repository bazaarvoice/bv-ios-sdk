//
//  BVProductPageViews.m
//  BVConversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductPageViews.h"
#import "BVConversationsAnalyticsUtil.h"


@interface BVProductDisplayPageViewController() {
    bool hasSentPageviewEvent;
}
@end

@implementation BVProductDisplayPageViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!hasSentPageviewEvent && self.product != nil) {
        hasSentPageviewEvent = true;
        [BVConversationsAnalyticsUtil queueAnalyticsEventForProductPageView:self.product];
    }
}

@end



@interface BVProductDisplayPageTableViewController(){
    bool hasSentPageviewEvent;
}
@end

@implementation BVProductDisplayPageTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!hasSentPageviewEvent && self.product != nil) {
        hasSentPageviewEvent = true;
        [BVConversationsAnalyticsUtil queueAnalyticsEventForProductPageView:self.product];
    }
}

@end



@interface BVProductDisplayPageCollectionViewController() {
    bool hasSentPageviewEvent;
}
@end

@implementation BVProductDisplayPageCollectionViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!hasSentPageviewEvent && self.product != nil) {
        hasSentPageviewEvent = true;
        [BVConversationsAnalyticsUtil queueAnalyticsEventForProductPageView:self.product];
    }
}

@end
