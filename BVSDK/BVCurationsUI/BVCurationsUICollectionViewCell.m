//
//  BVCurationsCollectionViewCell.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsUICollectionViewCell.h"
#import "BVCurationsFeedItem.h"
#import "BVLogger+Private.h"
#import "UIImage+BundleLocator.h"

@interface BVCurationsUICollectionViewCell ()

@property(nonatomic, strong) UIImageView *socialImageView;
@property(nonatomic, strong) UIImageView *sourceIconImageView;
@property(nonatomic, strong) UIImageView *playIconImageView;

@end

@implementation BVCurationsUICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  if ([super initWithFrame:frame]) {
    [self setup];
  }

  return self;
}

- (void)dealloc {
  [_shouldLoadObject removeObserver:self forKeyPath:_shouldLoadKeypath];
}

- (void)setup {
  _socialImageView = [[UIImageView alloc] init];
  _socialImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_socialImageView];
  NSLayoutConstraint *heightSocial =
      [NSLayoutConstraint constraintWithItem:_socialImageView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                   attribute:NSLayoutAttributeHeight
                                  multiplier:1.0
                                    constant:0.0];
  NSLayoutConstraint *widthSocial =
      [NSLayoutConstraint constraintWithItem:_socialImageView
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:1.0
                                    constant:0.0];
  NSLayoutConstraint *centerXSocial =
      [NSLayoutConstraint constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_socialImageView
                                   attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                    constant:0.0];
  NSLayoutConstraint *centerYSocial =
      [NSLayoutConstraint constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_socialImageView
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                    constant:0.0];

  _playIconImageView = [[UIImageView alloc] init];
  _playIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
  _playIconImageView.image = [UIImage bundledImageNamed:@"play"];
  _playIconImageView.contentMode = UIViewContentModeScaleAspectFit;
  _playIconImageView.hidden = YES;
  [self.contentView addSubview:_playIconImageView];
  NSLayoutConstraint *centerXPlay =
      [NSLayoutConstraint constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_playIconImageView
                                   attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                    constant:0.0];
  NSLayoutConstraint *centerYPlay =
      [NSLayoutConstraint constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_playIconImageView
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                    constant:0.0];
  NSLayoutConstraint *heightPlay =
      [NSLayoutConstraint constraintWithItem:_playIconImageView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                    constant:45.0];
  heightSocial.priority = 1000;
  NSLayoutConstraint *widthPlay =
      [NSLayoutConstraint constraintWithItem:_playIconImageView
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_playIconImageView
                                   attribute:NSLayoutAttributeHeight
                                  multiplier:1.0
                                    constant:1.0];
  widthPlay.priority = 1000;
  NSLayoutConstraint *proportionalDimPlay =
      [NSLayoutConstraint constraintWithItem:_playIconImageView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                   attribute:NSLayoutAttributeHeight
                                  multiplier:0.3
                                    constant:1];
  proportionalDimPlay.priority = 999;

  _sourceIconImageView = [[UIImageView alloc] init];
  _sourceIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
  _sourceIconImageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.contentView addSubview:_sourceIconImageView];
  NSLayoutConstraint *heightMaxIcon =
      [NSLayoutConstraint constraintWithItem:_sourceIconImageView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                    constant:30.0];
  heightSocial.priority = 1000;
  NSLayoutConstraint *widthMaxIcon =
      [NSLayoutConstraint constraintWithItem:_sourceIconImageView
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_sourceIconImageView
                                   attribute:NSLayoutAttributeHeight
                                  multiplier:1.0
                                    constant:1.0];
  widthSocial.priority = 1000;
  NSLayoutConstraint *proportionalDim =
      [NSLayoutConstraint constraintWithItem:_sourceIconImageView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                   attribute:NSLayoutAttributeHeight
                                  multiplier:0.25
                                    constant:1];
  proportionalDim.priority = 999;
  NSLayoutConstraint *right =
      [NSLayoutConstraint constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeRightMargin
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_sourceIconImageView
                                   attribute:NSLayoutAttributeRightMargin
                                  multiplier:1.0
                                    constant:6.0];
  NSLayoutConstraint *bottom =
      [NSLayoutConstraint constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeBottomMargin
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:_sourceIconImageView
                                   attribute:NSLayoutAttributeBottomMargin
                                  multiplier:1.0
                                    constant:6.0];

  [NSLayoutConstraint activateConstraints:@[
    heightSocial, widthSocial, centerXSocial, centerYSocial, right, bottom,
    heightMaxIcon, widthMaxIcon, proportionalDim, centerXPlay, centerYPlay,
    widthPlay, heightPlay, proportionalDimPlay
  ]];
}

- (void)setCurationsFeedItem:(BVCurationsFeedItem *)curationsFeedItem {
  _curationsFeedItem = curationsFeedItem;
  [self updateUI];
}

- (void)updateUI {
  NSString *imgUrl = [self getThumbnailUrlForItem:_curationsFeedItem];

  _playIconImageView.hidden = YES;
  if (!_curationsFeedItem.photos.count && _curationsFeedItem.videos.count) {
    _playIconImageView.hidden = NO;
  }

  if (!imgUrl) {
    _socialImageView.image = [UIImage bundledImageNamed:@"placeholder"];
    return;
  }

  if (_loadImageHandler) {
    BOOL shouldLoadImage =
        [[_shouldLoadObject valueForKeyPath:_shouldLoadKeypath] boolValue];
    __weak typeof(self) weakSelf = self;
    _loadImageIsCachedHandler(imgUrl, ^(BOOL cached, NSString *cacheUrl) {
      if (!cached) {

        weakSelf.socialImageView.image =
            [UIImage bundledImageNamed:@"placeholder"];
      }

      if (!cached && !shouldLoadImage) {
        return;
      }

      weakSelf.loadImageHandler(imgUrl, ^(UIImage *image, NSString *url) {
        if ([url isEqualToString:[weakSelf getThumbnailUrlForItem:
                                               weakSelf.curationsFeedItem]]) {
          dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.socialImageView.image = image;
          });
        }
      });
    });
  } else {
    BVLogError(@"Curations item not loaded due to nil "
               @"BVCurationsFeedItemPressedHandler on "
               @"BVCurationsUICollectionView",
               BV_PRODUCT_CURATIONS_UI);
  }

  _sourceIconImageView.image =
      [self imageForChannel:_curationsFeedItem.channel];
}

- (NSString *)getThumbnailUrlForItem:(BVCurationsFeedItem *)feedItem {
  CGFloat screenScale = [[UIScreen mainScreen] scale];
  NSInteger dim = ceil(self.frame.size.height * screenScale);
  NSString *format = @"%@&width=%ld&height=%ld&exact=true";

  if (_curationsFeedItem.photos.count) {
    return [NSString
        stringWithFormat:format, _curationsFeedItem.photos[0].imageServiceUrl,
                         dim, dim];
  } else if (_curationsFeedItem.videos.count) {
    return [NSString
        stringWithFormat:format, _curationsFeedItem.videos[0].imageServiceUrl,
                         dim, dim];
  }

  return nil;
}

- (UIImage *)imageForChannel:(NSString *)channel {
  return [UIImage bundledImageNamed:[NSString stringWithFormat:@"%@", channel]];
}

- (void)setShouldLoadKeypath:(NSString *)shouldLoadKeypath {
  if (!_shouldLoadKeypath) {
    _shouldLoadKeypath = shouldLoadKeypath;
    [_shouldLoadObject addObserver:self
                        forKeyPath:shouldLoadKeypath
                           options:NSKeyValueObservingOptionNew
                           context:nil];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
  if (object == _shouldLoadObject) {
    [self updateUI];
  }
}

@end
