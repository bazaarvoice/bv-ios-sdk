//
//  BVRecommendationsCarouselView.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationsCarouselView.h"
#import "BVGetShopperProfile.h"
#import "BVCarouselCell.h"
#import "BVRecommendationsErrorView.h"

// 3rd Party
#import <SVProgressHUD/SVProgressHUD.h>

@interface BVRecommendationsCarouselView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property UICollectionView* collectionView;
@property UICollectionViewFlowLayout* layout;
@property NSMutableArray* recommendations;
@property BVRecommendationsErrorView* errorView;

@end

@implementation BVRecommendationsCarouselView

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

-(id)init {
    self = [super init];
    if(self){
        [self setupDefaults];
    }
    return self;
}

-(void)setupDefaults {
    self.recommendations = [NSMutableArray array];
    [self setupSubviews];
    [self loadRecommendations];
    
    self.errorView = (BVRecommendationsErrorView*)[[[NSBundle mainBundle] loadNibNamed:@"BVRecommendationsErrorView" owner:self options:nil] firstObject];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recommendationsUpdated) name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:nil];
}

-(void)recommendationsUpdated {
    [self loadRecommendations];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.layout.sectionInset = UIEdgeInsetsMake(self.topAndBottmPadding,
                                                self.leftAndRightPadding,
                                                self.topAndBottmPadding,
                                                self.leftAndRightPadding);
    
    self.layout.minimumInteritemSpacing = self.cellHorizontalSpacing;
    self.layout.itemSize = CGSizeMake(self.bounds.size.height - self.topAndBottmPadding * 2,
                                      self.bounds.size.height - self.leftAndRightPadding * 2);
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

-(void)reloadView {
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
}

-(void)setupSubviews {
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BVCarouselCell" bundle:nil] forCellWithReuseIdentifier:@"BVCarouselCell"];
    [self addSubview:self.collectionView];
    
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

-(void)loadRecommendations {
    
    BVGetShopperProfile *api = [[BVGetShopperProfile alloc] init];
    
    [api fetchProductRecommendations:20 withCompletionHandler:^(BVShopperProfile * _Nullable profile, NSError * _Nullable error) {
        
        // completion
        if (profile && !error){
            
            self.recommendations = [NSMutableArray arrayWithArray:profile.recommendations];
            
            NSLog(@"Recommendatons!: %lu", (unsigned long)[self.recommendations count]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadUserRecommendations:)]) {
                    
                    [self.delegate didLoadUserRecommendations:profile];
                    
                }
                
            });
            
            BOOL noRecommendations = [self.recommendations count] == 0;
            [self showErrorView:noRecommendations withText:@"No recommendations available"];

        } else {
            
            // log the error
            NSString* errorMessage = [NSString stringWithFormat:@"Recommendations failed to load. Error: %@", error];
            [[BVLogger sharedLogger] error:errorMessage];
            
            // notify delegate
            if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
                
                [self.delegate didFailToLoadWithError:error];
                
            }
            
            [self showErrorView:true withText:@"An error occurred"];
            
        }
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.recommendations count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BVCarouselCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BVCarouselCell" forIndexPath:indexPath];
    
    BVProduct* product = [self.recommendations objectAtIndex:indexPath.row];
    
    cell.recommendationsView.product = product;
    [cell.recommendationsView addTarget:self action:@selector(cellTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // let the delegate style the cell
    if(self.delegate && [self.delegate respondsToSelector:@selector(styleRecommendationsView:)]) {
        
        [self.delegate styleRecommendationsView:cell.recommendationsView];
        
    }
    
    return cell;
}

-(void)cellTapped:(BVRecommendationsSharedView*)tappedView {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:tappedView.product withFeatureUsed:TapShopNow];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectProduct:)]) {
        
        [self.delegate didSelectProduct:tappedView.product];
        
    } else {
        
        [[BVLogger sharedLogger] info:@"No `BVRecommendationUIDelegate` set for `BVRecommendationsCarouselView`. Action `didSelectProduct:` ignored."];
        
    }
    
}


@end
