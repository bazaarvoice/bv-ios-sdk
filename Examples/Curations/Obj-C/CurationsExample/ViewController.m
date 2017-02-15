//
//  ViewController.m
//  CurationsExample
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"
#import "ViewController.h"
#import <SDWebImage/SDWebImageManager.h>

@import BVSDK;

@interface ViewController () <BVCurationsUICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet BVCurationsUICollectionView *curationsCollectionView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintCarousel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintGrid;
@property(nonatomic, strong) SDWebImageManager *sdMngr;

@end

static const NSInteger kNumRowsStart = 2;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the Curations UI display properties
    self.curationsCollectionView.curationsDelegate = self;
    self.curationsCollectionView.groups = @[@"__all__"];
    self.curationsCollectionView.fetchSize = 40;
    self.curationsCollectionView.infiniteScrollEnabled = YES;
    self.curationsCollectionView.itemsPerRow = kNumRowsStart;
    self.curationsCollectionView.backgroundColor = [UIColor lightGrayColor];
    self.curationsCollectionView.bvCurationsUILayout = BVCurationsUILayoutGrid;
    [self.curationsCollectionView loadFeed];

    _stepper.value = kNumRowsStart;
    
    SDImageCache *cache = [[SDImageCache alloc]initWithNamespace:@"bvcurationsdemo"];
    SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    downloader.maxConcurrentDownloads = NSIntegerMax;
    downloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    _sdMngr = [[SDWebImageManager alloc]initWithCache:cache downloader:downloader];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Add Photo"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(didTapAddPhotoButton)];
    
    self.navigationItem.rightBarButtonItem = submitButton;
}

- (void)didTapAddPhotoButton {
    
    // Here we load our request with the groups we want to subit to and additional info.
    BVCurationsAddPostRequest *request = [[BVCurationsAddPostRequest alloc]
                                          initWithGroups:@[]
                                          withAuthorAlias:@"authorAlias"
                                          withToken:@"token"
                                          withText:@"Hello"];
    
    // We've hard-coded an image here for testing, where you would normally have the user select from a gallery or camera.
    request.image = [UIImage imageNamed:@"curations_test_image"];
    
    // Now we just post the share view controller with a couple of styling options.
    
    BVCurationsPostViewController *shareVC = [[BVCurationsPostViewController alloc]
                                               initWithPostRequest:request
                                               logoImage:[UIImage imageNamed:@"happy_icon"]
                                               bavBarColor:[UIColor orangeColor]
                                               navBarTintColor:[UIColor whiteColor]];
    
    shareVC.placeholder = @"Say something awesome\nabout your photo!";
    shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [shareVC setDidPressCancel:^{
        // completion
        [self.navigationController.presentingViewController dismissViewControllerAnimated:true completion:^{
            // completion
            NSLog(@"User tapped cancel.");
        }];
    }];
    
    [shareVC setDidBeginPost:^{
        // Here you could add your own spinner
        NSLog(@"Starting photo upload");
    }];
    
    [shareVC setDidPressCancel:^{
        // completion
        NSLog(@"User tapped cancel.");
        [self.navigationController.presentingViewController dismissViewControllerAnimated:true completion:^{
            // completion
        }];
    }];
    
    [shareVC setDidCompletePost:^(NSError * _Nullable error) {
        // completion
        if (error){
            NSLog(@"ERROR submitting photo: %@", error.localizedDescription);
        } else {
            NSLog(@"Success submitting photo.");
        }
    }];
    
    [self.navigationController presentViewController:shareVC animated:YES completion:^{
        // completion
    }];
    
}

- (IBAction)stepColumnCount:(UIStepper *)sender {
    
    if (sender.value > 0){
        if (self.curationsCollectionView.bvCurationsUILayout == BVCurationsUILayoutCarousel){
            self.curationsCollectionView.bvCurationsUILayout = BVCurationsUILayoutGrid;
            self.heightConstraintCarousel.active = NO;
            _heightConstraintGrid.active = YES;
        }
        self.curationsCollectionView.itemsPerRow = sender.value;
    } else {
        self.curationsCollectionView.bvCurationsUILayout = BVCurationsUILayoutCarousel;
        _heightConstraintGrid.active = NO;
        self.heightConstraintCarousel.active = YES;
    }
    
    [self.view layoutIfNeeded];
}


// MARK: BVCurationsUICollectionViewDelegate


- (void)curationsLoadImage:(NSString *)imageUrl completion:(BVCurationsLoadImageCompletion)completion {
    
    [_sdMngr loadImageWithURL:[NSURL URLWithString:imageUrl] options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        // progress
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        completion(image, imageUrl);
    }];
    
}

- (void)curationsImageIsCached:(NSString *)imageUrl completion:(BVCurationsIsImageCachedCompletion)completion {
    [_sdMngr cachedImageExistsForURL:[NSURL URLWithString:imageUrl] completion:^(BOOL isInCache) {
        completion(isInCache, imageUrl);
    }];
}

- (void)curationsDidSelectFeedItem:(BVCurationsFeedItem *)feedItem {
    // Handle your click logic here...
    NSLog(@"Selected item: %@", feedItem.description);
}

-(void)curationsFailedToLoadFeed:(NSError *)error {
    NSLog(@"An error occurred: %@", error);
}

@end
