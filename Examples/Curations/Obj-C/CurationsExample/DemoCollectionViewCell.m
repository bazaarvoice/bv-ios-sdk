//
//  DemoCollectionViewCell.m
//  
//
//  Created by Tim Kelly on 5/25/16.
//
//

#import "DemoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DemoCollectionViewCell()

@property IBOutlet UIImageView *feedImageView;

@end

@implementation DemoCollectionViewCell

- (void)setFeedItem:(BVCurationsFeedItem *)feedItem {
    
    super.feedItem = feedItem;
    
    BVCurationsPhoto *curationsPhoto = self.feedItem.photos.firstObject;
    NSURL *imageURL = [NSURL URLWithString:curationsPhoto.url];
    
    [self.feedImageView sd_setImageWithURL:imageURL];
    
}

@end