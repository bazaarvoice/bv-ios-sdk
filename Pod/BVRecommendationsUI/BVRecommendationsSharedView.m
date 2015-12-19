//
//  BVRecommendationsSharedView.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationsSharedView.h"
#import "BVAnalyticsManager.h"
#import "BVRecsAnalyticsHelper.h"

// 3rd Party
#import <SDWebImage/UIImageView+WebCache.h>

@interface BVRecommendationsSharedView()

// Interface Outlets
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *numReviews;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIImageView *quoteImageView;
@property (weak, nonatomic) IBOutlet UILabel *productQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRating;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint* starsSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* pricePaddingConstraint;


@end

@implementation BVRecommendationsSharedView

- (void)awakeFromNib {
    
    // Initialization code
    self.likeImage = [UIImage imageNamed:@"like-unselected"];
    self.likeImageSelected = [UIImage imageNamed:@"heart-filled"];
    self.dislikeImage = [UIImage imageNamed:@"dislike-unselected"];
    self.dislikeImageSelected = [UIImage imageNamed:@"dislike"];
    
    // Quote image
    self.quoteImage = [UIImage imageNamed:@"icon-quote"];
    
    // Stars
    self.starsColor = [UIColor colorWithRed:1.0 green:0.73 blue:0.04 alpha:1.0];
    self.starsEmptyImage = nil; // HCSStarRatingView has a sensible default for star images
    self.starsFilledImage = nil;

    // visibility of elements
    self.starsAndReviewStatsHidden = false;
    self.reviewAndAuthorHidden = false;
    self.authorHidden = false;
    self.priceHidden = false;
    self.shopButtonHidden = false;
    self.likeButtonHidden = false;
    self.dislikeButtonHidden = false;
    
    [self setupStarRatingView];
}

- (void)setupStarRatingView {
    
    self.starsColor = [UIColor colorWithRed:1.0 green:0.73 blue:0.04 alpha:1.0]; // yellow
    
    self.starsEmptyImage = nil; // HCSStarRatingView has good default imge if nil
    self.starsFilledImage = nil;
    self.starsAndReviewStatsHidden = false;
    
    self.starRating.contentMode = UIViewContentModeRedraw; // needed for proper autolayout
    self.starRating.allowsHalfStars = YES;
    self.starRating.accurateHalfStars = YES;
    self.starRating.minimumValue = 0;
    self.starRating.maximumValue = 5;
    self.starRating.userInteractionEnabled = NO;
    
}

-(void)setStarsAndReviewStatsHidden:(BOOL)starsAndReviewStatsHidden {
    
    _starsAndReviewStatsHidden = starsAndReviewStatsHidden;
    
    self.starRating.hidden = starsAndReviewStatsHidden;
    self.rating.hidden = starsAndReviewStatsHidden;
    self.numReviews.hidden = starsAndReviewStatsHidden;
    
    self.starsSpacing.constant = starsAndReviewStatsHidden ? 0 : 8;
    
    if(starsAndReviewStatsHidden){
        self.rating.text = @"";
    }
}

-(void)setReviewAndAuthorHidden:(BOOL)reviewAndAuthorHidden {
    
    _reviewAndAuthorHidden = reviewAndAuthorHidden;
    
    self.productQuoteLabel.hidden = reviewAndAuthorHidden;
    self.authorLabel.hidden = reviewAndAuthorHidden;
    self.locationLabel.hidden = reviewAndAuthorHidden;
    self.quoteImageView.hidden = reviewAndAuthorHidden;
    
    if (reviewAndAuthorHidden) {
        self.productQuoteLabel.text = @"";
        self.authorLabel.text = @"";
        self.locationLabel.text = @"";
    }
}

-(void)setAuthorHidden:(BOOL)authorHidden {
    
    _authorHidden = authorHidden;
    
    self.authorLabel.hidden = authorHidden;
    self.locationLabel.hidden = authorHidden;
    self.quoteImageView.hidden = authorHidden;
    
    if (authorHidden) {
        self.authorLabel.text = @"";
        self.locationLabel.text = @"";
    }
}

-(void)setPriceHidden:(BOOL)priceHidden {
    
    _priceHidden = priceHidden;
    self.price.hidden = _priceHidden;
    
    if (_priceHidden) {
        self.price.text = @"";
        self.pricePaddingConstraint.constant = 0;
    }
    else {
        self.pricePaddingConstraint.constant = 8;
    }
}

-(void)setShopButtonHidden:(BOOL)shopButtonHidden {
    
    _shopButtonHidden = shopButtonHidden;
    
    self.shopButton.hidden = shopButtonHidden;
}

-(void)setLikeButtonHidden:(BOOL)likeButtonHidden {
    
    _likeButtonHidden = likeButtonHidden;
    
    self.likeButton.hidden = likeButtonHidden;
}

-(void)setDislikeButtonHidden:(BOOL)dislikeButtonHidden {
    
    _dislikeButtonHidden = dislikeButtonHidden;
    
    self.dislikeButton.hidden = dislikeButtonHidden;
}

-(void)setStarsColor:(UIColor *)starsColor {
    
    _starsColor = starsColor;
    
    self.starRating.tintColor = starsColor;
}

-(void)setStarsEmptyImage:(UIImage *)starsEmptyImage {
    
    _starsEmptyImage = starsEmptyImage;
    
    self.starRating.emptyStarImage = [starsEmptyImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
}
-(void)setStarsFilledImage:(UIImage *)starsFilledImage {
    
    _starsFilledImage = starsFilledImage;
    
    self.starRating.filledStarImage = [starsFilledImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
}

-(void)setFontName:(NSString*)fontName boldFontName:(NSString*)boldFontName {
    
    if(fontName == nil) {
        fontName = @"HelveticaNeue";
    }
    
    if(boldFontName == nil) {
        boldFontName = @"HelveticaNeueBold";
    }

    // Set fonts on labels -- keep size/properties from xib
    [self setFontFamily:fontName forView:self.productName];
    [self setFontFamily:fontName forView:self.numReviews];
    [self setFontFamily:boldFontName forView:self.price];
    [self setFontFamily:fontName forView:self.rating];
    [self setFontFamily:fontName forView:self.productQuoteLabel];
    [self setFontFamily:fontName forView:self.authorLabel];
    [self setFontFamily:fontName forView:self.locationLabel];
}


#pragma mark - IBActions + Delegates

- (IBAction)toggleLike:(id)sender {
    
    self.isLiked = !self.isLiked;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(_didToggleLike:withNewValue:)]){
        [self.delegate _didToggleLike:self.product withNewValue:self.isLiked];
    }
}


- (IBAction)toggleDislike:(id)sender {
    
    self.isDisliked = !self.isDisliked;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(_didToggleDislike:withNewValue:shouldRemove:)]){
        [self.delegate _didToggleDislike:self.product withNewValue:self.isDisliked shouldRemove:self.removeCellOnDislike];
    }
    
}


- (IBAction)shopNow:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(_didSelectShopNow:)]){
        [self.delegate _didSelectShopNow:self.product];
    }
    
}


- (void)setIsLiked:(BOOL)isLiked {
    
    _isLiked = isLiked;
    
    if (self.isLiked){
        [self setIsDisliked:NO];
    }
    
    [self.likeButton setImage:(self.isLiked ? self.likeImageSelected : self.likeImage) forState:UIControlStateNormal];
    
}

- (void)setIsDisliked:(BOOL)isDisliked {
    
    _isDisliked = isDisliked;
    
    if (self.isDisliked){
        [self setIsLiked:NO];
    }
    
    [self.dislikeButton setImage:(self.isDisliked ? self.dislikeImageSelected : self.dislikeImage) forState:UIControlStateNormal];
}


#pragma mark Property setters

- (void)setProduct:(BVProduct *)product{
    
    _product = product;
    
    self.productName.text = product.name;

    self.numReviews.text = [NSString stringWithFormat:@"(%ld reviews)", (long)[product.num_reviews integerValue]];
    self.rating.text = [NSString stringWithFormat:@"%.1f", [product.avg_rating floatValue]];
    self.starRating.value = [product.avg_rating floatValue];
    
    self.productQuoteLabel.text = product.reviewText;
    self.authorLabel.text = product.reviewAuthor;
    self.locationLabel.text = product.reviewAuthorLocation;

    bool hideQuoteImage = product.reviewText == nil || [product.reviewText length] == 0;
    self.quoteImageView.hidden = hideQuoteImage;
    
    self.price.text = product.price;
    if (product.price == nil || [product.price length] == 0) {
        self.pricePaddingConstraint.constant = 0;
    }
    else {
        self.pricePaddingConstraint.constant = 8;
    }

    
    // TODO: Can add option for fade image in.
    // TODO: Need to have a placeholder in event image load fails.
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:product.image_url]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        
//                                        //adjust aspect ratio if needed
//                                        if(image == nil){
//                                            self.productImageView.image = nil;
//                                            NSString* errMessage = [NSString stringWithFormat:@"Error downloading image: %@ with error message: %@", product.image_url, error.localizedDescription];
//                                            [[BVLogger sharedLogger] info:errMessage];
//                                        }
//                                        else {
//                                            if (image.size.height < self.productImageView.frame.size.height && image.size.width < self.productImageView.frame.size.width) {
//                                                self.productImageView.contentMode = UIViewContentModeCenter;
//                                            }
//                                            else {
//                                                self.productImageView.contentMode = UIViewContentModeScaleAspectFit;
//                                            }
//                                        }

                                    }];
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProdctView:product];
    
}

- (UIImage *)image:(UIImage *)image withTintColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel*)view;
        [label setFont: [UIFont fontWithName:fontFamily size:[[label font] pointSize]]];
    }
    
}

@end
