//
//  BVRecommendationsTableViewController.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationsTableViewController.h"
#import "BVGetShopperProfile.h"
#import "BVProductLargeTableViewCell.h"
#import "BVProductSmallTableViewCell.h"
#import "BVRecommendationCellDelegate.h"
#import "BVRecsAnalyticsHelper.h"
#import "BVRecommendationsErrorView.h"

// 3rd Party
#import <SVProgressHUD/SVProgressHUD.h>

#define PRODUCT_CELL_LARGE_REUSE_ID @"BVProductLargeTableViewCell"
#define PRODUCT_CELL_SMALL_REUSE_ID @"BVProductSmallTableViewCell"

@interface BVRecommendationsTableViewController () <BVRecommendationCellDelegate, BVRecommendationsUIDataSource>

@property (strong, nonatomic) BVShopperProfile *profileRecs; // API result model

@property (strong, nonatomic) NSMutableArray *recommendations; // internal, mutable copy of model

@property (strong, nonatomic) NSMutableSet *likedProductIds;
@property (strong, nonatomic) NSMutableSet *dislikedProductIds;

@property (strong, nonatomic) NSString *cellTypeReuseId;

@property BVRecommendationsErrorView* errorView;

@end

@implementation BVRecommendationsTableViewController

- (id)init {
    self = [super init];
    if(self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        [self setupDefaults];
    }
    return self;
}

-(void)setupDefaults {
    self.recommendationSettings = [[BVRecommendationContinerProps alloc] init];
    self.progressWheelText = @"Loading...";
    self.progressWheelColor = [UIColor blackColor];
    self.progressWheelBackgroundColor = [UIColor whiteColor];
    
    NSBundle* bundle = [NSBundle bundleWithIdentifier:BV_RECSUI_FRAMEWORK_BUNDLE_ID];
    
    self.errorView = (BVRecommendationsErrorView*)[[bundle loadNibNamed:@"BVRecommendationsErrorView" owner:self options:nil] firstObject];

    if (!self.errorView){
        // statically built into app, load from app main bundle
        self.errorView = (BVRecommendationsErrorView*)[[[NSBundle mainBundle] loadNibNamed:@"BVRecommendationsErrorView" owner:self options:nil] firstObject];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recommendationsUpdated) name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:nil];
}


- (void)refreshView{
    [self.tableView reloadData];
}

-(void)reloadView{
    [self fetchProductRecommendations];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BV_INTERNAL_PROFILE_UPDATED_COMPLETED object:nil];
}

-(void)recommendationsUpdated {
    [self fetchProductRecommendations];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // enable autolayout of cells
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Set which nib we should use to draw the UI
    if (self.cellType == BVProductCellTypeSmall){
        self.cellTypeReuseId = PRODUCT_CELL_SMALL_REUSE_ID;
    } else {
        self.cellTypeReuseId = PRODUCT_CELL_LARGE_REUSE_ID;
    }
    
    self.likedProductIds = [NSMutableSet set];
    self.dislikedProductIds = [NSMutableSet set];
    
    UINib *nib = [UINib nibWithNibName:self.cellTypeReuseId bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:self.cellTypeReuseId];
    
    if (self.profileRecs == nil){
        [self fetchProductRecommendations];
    } else {
        // refresh ui
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadUserRecommendations:)]){
            
            [self.delegate didLoadUserRecommendations:self.profileRecs];
            
        }
        
        [self.tableView reloadData];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showProgressHUD {
    if(self.progressWheelBackgroundColor == nil && self.progressWheelColor == nil && self.progressWheelText == nil){
            return;
    }
    
    [SVProgressHUD setBackgroundColor:self.progressWheelBackgroundColor];
    [SVProgressHUD setForegroundColor:self.progressWheelColor];
    [SVProgressHUD setStatus:self.progressWheelText];
    
    [SVProgressHUD showWithStatus:self.progressWheelText];
}

-(void)showErrorView:(BOOL)showErrorView withText:(NSString*)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(showErrorView) {
            self.errorView.errorLabel.text = message;
            self.errorView.frame = self.view.bounds;
            [self.view addSubview:self.errorView];
        }
        else {
            [self.errorView removeFromSuperview];
        }
        
    });
    
}

- (void)fetchProductRecommendations{
    
    [self showProgressHUD];
    
    NSString *productId = self.recommendationSettings.productId;
    NSString *categoryId = self.recommendationSettings.categoryId;
    NSUInteger limit = self.recommendationSettings.recommendationLimit;
    
    BVGetShopperProfile *api = [[BVGetShopperProfile alloc] init];
    
    [api _privateFetchShopperProfile:productId withCategoryId:categoryId withProfileOptions:0 withLimit:limit completionHandler:^(BVShopperProfile * _Nullable profile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // completion
        if (profile && !error){
            
            // success
            self.profileRecs = profile;
            
            self.recommendations = [NSMutableArray arrayWithArray:self.profileRecs.recommendations];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // refresh ui
                if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadUserRecommendations:)]){
                    
                    [self.delegate didLoadUserRecommendations:self.profileRecs];
                    
                }
                
                [self.tableView reloadData];
                
                 [BVRecsAnalyticsHelper queueEmbeddedRecommendationsPageViewEvent:self.recommendationSettings.productId withCategoryId:self.recommendationSettings.categoryId withClientId:[BVSDKManager sharedManager].clientId withNumRecommendations:self.recommendations.count withWidgetType:[BVRecsAnalyticsHelper getWidgetTypeString:RecommendationsTableView]];

                
            });
            
            BOOL noRecommendations = [self.recommendations count] == 0;
            [self showErrorView:noRecommendations withText:@"No recommendations available"];
            
            
        } else {
            // error
            if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
                [self.delegate didFailToLoadWithError:error];
            }
            else {
                NSString* errorMessage = [NSString stringWithFormat:@"Recommendations failed to load, and delegate was not set to handle this error. Error: %@", error];
                [[BVLogger sharedLogger] error:errorMessage];
            }
            
            [self showErrorView:true withText:@"An error occurred"];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    }];
    
   
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.recommendations){
        return [self.recommendations count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BVProductLargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellTypeReuseId];
        
    // Configure the cell...
    BVProduct *product = [self.recommendations objectAtIndex:indexPath.row];
    
    // Setting the product configures the UI elements in the cell
    cell.recommendationsView.isDisliked = [self isBannedProduct:product.productId];
    cell.recommendationsView.isLiked = [self isFavoriteProduct:product.productId];
    [cell.recommendationsView addTarget:self action:@selector(cellTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.recommendationsView.product = product;
    
    if(self.datasource && [self.datasource respondsToSelector:@selector(styleRecommendationsView:)]) {
        [self.datasource styleRecommendationsView:cell.recommendationsView];
    }
    
    cell.recommendationsView.delegate = self;
    
    return cell;
}


- (BOOL)isBannedProduct:(NSString *)productId{
    return [self.dislikedProductIds containsObject:productId];
}


- (BOOL)isFavoriteProduct:(NSString *)productId{
    return [self.likedProductIds containsObject:productId];
}

-(void)cellTapped:(BVRecommendationsSharedView*)tappedView {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:tappedView.product withFeatureUsed:TapProduct withWidgetType:RecommendationsTableView];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectProduct:)]) {
        
        [self.delegate didSelectProduct:tappedView.product];
        
    } else {
        
        [[BVLogger sharedLogger] info:@"No `BVRecommendationUIDelegate` set for `BVRecommendationsTableViewController`. Action `didSelectProduct:` ignored."];
        
    }
    
}


#pragma mark - BVRecommendationCellDelegate

-(void)_didToggleLike:(BVProduct *)product withNewValue:(BOOL)flag {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:product withFeatureUsed:TapLike withWidgetType:RecommendationsTableView];
    
    [self.dislikedProductIds removeObject:product.productId];
    
    if (flag){
        [self.likedProductIds addObject:product.productId];
    } else {
        [self.likedProductIds removeObject:product.productId];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didToggleLike:)]){
        [self.delegate didToggleLike:product];
    }
    else {
        
        [self warnIgnoredAction:@"didToggleLike:"];
        
    }
}

-(void)_didToggleDislike:(BVProduct *)product withNewValue:(BOOL)flag shouldRemove:(BOOL)remove {
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:product withFeatureUsed:TapUnlike withWidgetType:RecommendationsTableView];
    
    [self.likedProductIds removeObject:product.productId];
    
    if (remove) {
        NSUInteger index = [self.recommendations indexOfObject:product];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView beginUpdates];
        [self.recommendations removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    if (flag){
        [self.dislikedProductIds addObject:product.productId];
    } else {
        [self.dislikedProductIds removeObject:product.productId];
    }
    
    // notify delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(didToggleDislike:)]){
        [self.delegate didToggleDislike:product];
    }
    else {
        
        [self warnIgnoredAction:@"didToggleDislike:"];
        
    }
    
}

- (void)_didSelectShopNow:(BVProduct *)product{
    
    [BVRecsAnalyticsHelper queueAnalyticsEventForProductFeatureUsed:product withFeatureUsed:TapShopNow withWidgetType:RecommendationsTableView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectShopNow:)]){
        
        [self.delegate didSelectShopNow:product];
        
    }
    else {
    
        [self warnIgnoredAction:@"didSelectShopNow:"];
        
    }
    
}

-(void)warnIgnoredAction:(NSString*)ignoredAction {
    NSString* message = [NSString stringWithFormat:@"`BVRecommendationsUIDelegate` not set, or does not respond for `BVRecommendationsTableViewController`. Action `%@` ignored.", ignoredAction];
    [[BVLogger sharedLogger] warning:message];
}


#pragma mark - BVRecommendationsUIDataSource

- (void)setDatasource:(id<BVRecommendationsUIDataSource>)inDataSource{
    
    _datasource = inDataSource;
    
    if (inDataSource && [inDataSource respondsToSelector:@selector(setForFavoriteProductIds)]){
        self.likedProductIds = [_datasource setForFavoriteProductIds];
    }
    
    if (inDataSource && [inDataSource respondsToSelector:@selector(setForBannedProductIds)]){
        self.dislikedProductIds = [_datasource setForBannedProductIds];
    }
    
    [self.tableView reloadData];
}


#pragma mark UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [BVRecsAnalyticsHelper queueAnalyticsEventForWidgetScroll:RecommendationsTableView];
}

@end
