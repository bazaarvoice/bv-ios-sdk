//
//  BVRecommendationsSharedView.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVRecommendationsSharedView_h
#define BVRecommendationsSharedView_h

#import <UIKit/UIKit.h>
#import "BVRecommendationCellDelegate.h"

// 3rd Party
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface BVRecommendationsSharedView : UIControl

/**
 *  The BVProduct to show in this view.
 */
@property (strong, nonatomic) BVProduct *product;

/**
 *  When removeCellOnDislike == true, the cell will be removed from the parent view when the user taps the dislike button.
 */
@property (nonatomic) BOOL removeCellOnDislike;

/**
 *  Set whether the user has liked or dislike the product.
 */
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL isDisliked;

/**
 *  Hide/show various elements of the cell.
 */
@property (nonatomic) BOOL starsAndReviewStatsHidden;
@property (nonatomic) BOOL reviewAndAuthorHidden;
@property (nonatomic) BOOL authorHidden;
@property (nonatomic) BOOL priceHidden;
@property (nonatomic) BOOL shopButtonHidden;
@property (nonatomic) BOOL likeButtonHidden;
@property (nonatomic) BOOL dislikeButtonHidden;

/**
 *  Font name (and bold font name) to use throughout the cell
 */
-(void)setFontName:(NSString*)fontName boldFontName:(NSString*)boldFontName;

/**
 *  shopButton can be styled as desired.
 */
@property (weak, nonatomic) IBOutlet UIButton *shopButton;

/**
 *  Configure the 5 stars shown. Leaving starsEmptyImage and starsFilledImage as nil will fall back to standard stars.
 */
@property (nonatomic, strong) UIColor *starsColor;
@property (nonatomic, strong) UIImage *starsEmptyImage;
@property (nonatomic, strong) UIImage *starsFilledImage;

/**
 *  Configure the normal and selected images of the like and dislike button.
 */
@property (strong, nonatomic) UIImage *likeImage;
@property (strong, nonatomic) UIImage *likeImageSelected;
@property (strong, nonatomic) UIImage *dislikeImage;
@property (strong, nonatomic) UIImage *dislikeImageSelected;

/**
 *  Image to use for quotation next to review
 */
@property (strong, nonatomic) UIImage *quoteImage;

/**
 *  Separator lines, used for BVRecommendationsTableViewController
 */
@property (weak, nonatomic) IBOutlet UIView *topBorderSeparator;
@property (weak, nonatomic) IBOutlet UIView *buttonBorderSeparator;

/**
 *  Internal - propagate actions to the sdk consumer
 */
@property id<BVRecommendationCellDelegate> delegate;

@end

#endif
