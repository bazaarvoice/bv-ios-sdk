//
//  ViewController.m
//  CurationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"
#import <BVSDK/BVCurations.h>

#import "ViewController.h"
#import "DemoCollectionViewCell.h"
#import <BVSDK/BVCurations.h>

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet BVCurationsCollectionView *curationsCollectionView;

@property (strong, nonatomic) NSArray<BVCurationsFeedItem *> *curationsFeedItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.curationsFeedItems = [NSArray array];
    
    // Set up the UI
    [self.curationsCollectionView registerNib:[UINib nibWithNibName:@"DemoCollectionViewCell" bundle:nil]
                   forCellWithReuseIdentifier:@"DemoCell"];
    
    self.curationsCollectionView.delegate = self;
    self.curationsCollectionView.dataSource = self;
    
    // Create the request parameters
    NSArray *groups = @[@"__all__"];
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:groups];
    feedRequest.limit = 40;
    feedRequest.hasPhoto = YES;
    feedRequest.withProductData = YES;
    
    [self.curationsCollectionView loadFeedWithRequest:feedRequest withWidgetId:nil completionHandler:^(NSArray<BVCurationsFeedItem *> * _Nonnull feedItemsResult) {
        // completion on main thread
        NSLog(@"Success loading Curations Display!");
        self.curationsFeedItems = feedItemsResult;
        [self.curationsCollectionView reloadData];
        
    } withFailure:^(NSError * _Nonnull error) {
        // error on main thread
        NSLog(@"ERROR: Curations feed could not be retrieved. Error: %@", error.localizedDescription);
    }];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.curationsCollectionView.collectionViewLayout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(self.curationsCollectionView.bounds.size.width / 2, self.curationsCollectionView.bounds.size.width / 2);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.curationsFeedItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DemoCollectionViewCell *cell = [self.curationsCollectionView dequeueReusableCellWithReuseIdentifier:@"DemoCell" forIndexPath:indexPath];
    
    cell.feedItem = [self.curationsFeedItems objectAtIndex:indexPath.row];
    
    return cell;
    
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BVCurationsFeedItem *selectedFeedItem = [self.curationsFeedItems objectAtIndex:indexPath.row];
    
    NSLog(@"Selected: %@", selectedFeedItem.description);
    
}

@end