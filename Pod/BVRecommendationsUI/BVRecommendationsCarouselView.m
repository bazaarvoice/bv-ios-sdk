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
    self.recommendationSettings = [[BVRecommendationContinerProps alloc] init];
    [self setupSubviews];
    
    NSBundle* bundle = [NSBundle bundleWithIdentifier:BV_RECSUI_FRAMEWORK_BUNDLE_ID];
    
    self.errorView = (BVRecommendationsErrorView*)[[bundle loadNibNamed:@"BVRecommendationsErrorView" owner:self options:nil] firstObject];
    
    if (!self.errorView){
        // statically built into app, load from app main bundle
        self.errorView = (BVRecommendationsErrorView*)[[[NSBundle mainBundle] loadNibNamed:@"BVRecommendationsErrorView" owner:self options:nil] firstObject];
    }
    
}

-(void)dealloc {
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

- (void)refreshView {
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
}

-(void)reloadView {
    [self loadRecommendations];
}

-(void)setupSubviews {
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    NSBundle* bundle = [NSBundle bundleWithIdentifier:BV_RECSUI_FRAMEWORK_BUNDLE_ID];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BVCarouselCell" bundle:bundle] forCellWithReuseIdentifier:@"BVCarouselCell"];
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
    
    UIActivityIndicatorView *wheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSString *productId = self.recommendationSettings.productId;
    NSString *categoryId = self.recommendationSettings.categoryId;
    NSUInteger limit = self.recommendationSettings.recommendationLimit;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setNeedsLayout];
        wheel.frame = self.bounds;
        [self addSubview:wheel];
        [wheel startAnimating];
    });
    
    BVGetShopperProfile *api = [[BVGetShopperProfile alloc] init];
    
    [api _privateFetchShopperProfile:productId withCategoryId:categoryId withProfileOptions:0 withLimit:limit completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // completion
        dispatch_async(dispatch_get_main_queue(), ^{
            [wheel removeFromSuperview];
        });
        
        // completion
        if (profile && !error){
            
            self.recommendations = [NSMutableArray arrayWithArray:profile.recommendations];
            
            NSLog(@"Recommendatons!: %lu", (unsigned long)[self.recommendations count]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadUserRecommendations:)]) {
                    
                    [self.delegate didLoadUserRecommendations:profile];
                    
                }
                
                [BVRecsAnalyticsHelper queueEmbeddedRecommendationsPageViewEvent:self.recommendationSettings.productId withCategoryId:self.recommendationSettings.categoryId withClientId:[BVSDKManager sharedManager].clientId withNumRecommendations:self.recommendations.count withWidgetType:[BVRecsAnalyticsHelper getWidgetTypeString:RecommendationsCarousel]];
                
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
    if(self.datasource && [self.datasource respondsToSelector:@selector(styleRecommendationsView:)]) {
        
        [self.datasource styleRecommendationsView:cell.recommendationsView];
        
    }
    
    return cell;
}

-(void)cellTapped:(BVRecommendationsSharedView*)tappedView {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:tappedView.product withFeatureUsed:TapShopNow withWidgetType:RecommendationsCarousel];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectProduct:)]) {
        
        [self.delegate didSelectProduct:tappedView.product];
        
    } else {
        
        [[BVLogger sharedLogger] info:@"No `BVRecommendationUIDelegate` set for `BVRecommendationsCarouselView`. Action `didSelectProduct:` ignored."];
        
    }
    
}


-(void)setDatasource:(id<BVRecommendationsUIDataSource>)datasource{
    
    // make the API call once the datasource is set.
    _datasource = datasource;
    [self loadRecommendations];
    
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [BVRecsAnalyticsHelper queueAnalyticsEventForWidgetScroll:RecommendationsCarousel];
}

@end
