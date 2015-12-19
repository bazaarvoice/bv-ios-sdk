//
//  BVRecommendationsStaticView.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationsStaticView.h"
#import "BVGetShopperProfile.h"
#import "BVStaticViewCell.h"
#import "BVRecommendationsErrorView.h"

@interface BVRecommendationsStaticView()<BVRecommendationCellDelegate>

@property int numberOfRecs;
@property NSMutableArray* recommendations;
@property NSMutableArray* staticViewCells;
@property NSMutableArray* separatorViews;
@property BVRecommendationsErrorView* errorView;

@end

@implementation BVRecommendationsStaticView

-(id)init {
    self = [super init];
    if(self){
        [self setupDefaults];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setupDefaults];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupDefaults];
    }
    return self;
}

-(void)setupDefaults {
    self.recommendations = [NSMutableArray array];
    self.separatorViews = [NSMutableArray array];
    self.numberOfRecs = 3; // default 3 recommendations
    self.separatorColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
    
    self.errorView = (BVRecommendationsErrorView*)[[[NSBundle mainBundle] loadNibNamed:@"BVRecommendationsErrorView" owner:self options:nil] firstObject];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recommendationsUpdated) name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:nil];
}

-(void)recommendationsUpdated {
    [self getRecommendations];
}

-(void)configureNumberOfRecommendations:(int)numberOfRecommendations {
    self.numberOfRecs = numberOfRecommendations;
    [self getRecommendations];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutCells];
}

-(void)layoutCells {

    CGRect cellFrame = self.bounds;
    cellFrame.size.height /= self.numberOfRecs;
    cellFrame.size.height -= self.cellPadding;
    cellFrame.origin.y += self.cellPadding / 2;
    cellFrame.origin.x += self.cellPadding / 2;
    cellFrame.size.width -= self.cellPadding;
    CGRect currentCellFrame = cellFrame;
    
    // layout cells
    for (BVStaticViewCell* cell in self.staticViewCells) {
        cell.frame = currentCellFrame;
        
        currentCellFrame.origin.y += currentCellFrame.size.height + self.cellPadding;
    }
    
    // layout cell separator
    currentCellFrame = cellFrame;
    for (UIView* separator in self.separatorViews) {
        separator.frame = CGRectMake(self.cellPadding,
                                     CGRectGetMaxY(currentCellFrame),
                                     currentCellFrame.size.width - self.cellPadding * 2,
                                     0.5);
        
        currentCellFrame.origin.y += currentCellFrame.size.height + self.cellPadding;
    }
}

-(void)showErrorView:(BOOL)showErrorView withText:(NSString*)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(showErrorView) {
            self.errorView.errorLabel.text = message;
            self.errorView.frame = self.bounds;
            [self addSubview:self.errorView];
        }
        else {
            [self.errorView removeFromSuperview];
        }
        
    });
    
}

-(void)getRecommendations {
    
    BVGetShopperProfile *api = [[BVGetShopperProfile alloc] init];
    
    [api fetchProductRecommendations:self.numberOfRecs withCompletionHandler:^(BVShopperProfile * _Nullable profile, NSError * _Nullable error) {
        
        // completion
        if (profile && !error){
            
            self.recommendations = [NSMutableArray arrayWithArray:profile.recommendations];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshView];
                
                // notify delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadUserRecommendations:)]){
                    
                    [self.delegate didLoadUserRecommendations:profile];
                    
                }
                
            });
            
            BOOL noRecommendations = [self.recommendations count] == 0;
            [self showErrorView:noRecommendations withText:@"No recommendations available"];
            
        } else {
            
            // error
            NSString* errorMessage = [NSString stringWithFormat:@"Recommendations failed to load. Error: %@", error];
            [[BVLogger sharedLogger] error:errorMessage];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
                [self.delegate didFailToLoadWithError:error];
            }

            [self showErrorView:true withText:@"An error occurred"];
            
        }
        
    }];
}

-(void)refreshView {
    
    if ([self.recommendations count] == 0){
        // Nothing to do we don't have any recommendations
        return;
    }
    
    self.staticViewCells = [NSMutableArray array];
    
    int recsAdded = 0;
    for (BVProduct* recommendation in self.recommendations) {
        
        if (recsAdded > self.numberOfRecs){
            break;
        }
        
        BVStaticViewCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"BVStaticViewCell" owner:nil options:nil] firstObject];
        cell.recommendationsView.product = recommendation;
        cell.recommendationsView.delegate = self;
        
        [cell.recommendationsView addTarget:self action:@selector(cellTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // let the delegate style the cell
        if(self.delegate && [self.delegate respondsToSelector:@selector(styleRecommendationsView:)]) {
            [self.delegate styleRecommendationsView:cell.recommendationsView];
        }
        
        [self addSubview:cell];
        
        [self.staticViewCells addObject:cell];
        
        ++recsAdded;
    }
    
    self.separatorViews = [NSMutableArray array];

    for(int i=0; i<[self.staticViewCells count]-1; i++) {
        
        UIView* separator = [[UIView alloc] init];
        separator.backgroundColor = self.separatorColor;
        
        [self addSubview:separator];
        
        [self.separatorViews addObject:separator];
    }
    
    [self layoutCells];
}

-(void)cellTapped:(BVRecommendationsSharedView*)tappedView {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:tappedView.product withFeatureUsed:TapProduct];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectProduct:)]) {
        
        [self.delegate didSelectProduct:tappedView.product];
        
    } else {
        
        [[BVLogger sharedLogger] info:@"No `BVRecommendationUIDelegate` set for `BVRecommendationsStaticView`. Action `didSelectProduct:` ignored."];
        
    }

}

#pragma mark - BVRecommendationCellDelegate


- (void)_didToggleLike:(BVProduct *)product withNewValue:(BOOL)flag {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:product withFeatureUsed:TapLike];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didToggleLike:)]) {
        
        [self.delegate didToggleLike:product];
        
    }
    else {
        
        [self warnIgnoredAction:@"didToggleLike:"];
        
    }
    
}

- (void)_didToggleDislike:(BVProduct *)product withNewValue:(BOOL)flag shouldRemove:(BOOL)remove {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:product withFeatureUsed:TapUnlike];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didToggleDislike:)]) {
        
        [self.delegate didToggleDislike:product];
        
    }
    else {
        
        [self warnIgnoredAction:@"didToggleDislike:"];
        
    }
    
}

- (void)_didSelectShopNow:(BVProduct *)product {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:product withFeatureUsed:TapShopNow];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectShopNow:)]) {

        [self.delegate didSelectShopNow:product];
        
    }
    else {
        
        [self warnIgnoredAction:@"didSelectShopNow:"];
        
    }
    
}

-(void)warnIgnoredAction:(NSString*)ignoredAction {
    NSString* message = [NSString stringWithFormat:@"`BVRecommendationsUIDelegate` not set, or does not respond for `BVRecommendationsStaticView`. Action `%@` ignored.", ignoredAction];
    [[BVLogger sharedLogger] warning:message];
}

@end
