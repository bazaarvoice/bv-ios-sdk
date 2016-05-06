//
//  ViewController.m
//  RecommendationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"
#import "DemoCell.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet BVProductRecommendationsCollectionView *recommendationsView;
@property NSArray*products;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.products = [NSArray array];
    
    [self.recommendationsView registerNib:[UINib nibWithNibName:@"DemoCell" bundle:nil]
               forCellWithReuseIdentifier:@"DemoCellIdentifier"];
    
    self.recommendationsView.delegate = self;
    self.recommendationsView.dataSource = self;
    
    [self loadRecommendations];
    
}

// Fetch the product recommenations from the API method on the BVRecommendationsCollectionView container.
- (void)loadRecommendations {
    
    BVRecommendationsRequest *request = [[BVRecommendationsRequest alloc] initWithLimit:20];
    
    [self.recommendationsView loadRequest:request completionHandler:^(NSArray * proudcts) {
        self.products = proudcts;
        [self.recommendationsView reloadData];
    } errorHandler:^(NSError * error) {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }];
    
}

// Lays out the recommendationView with horitontal scrolling
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.recommendationsView.collectionViewLayout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.recommendationsView.bounds.size.width / 2, self.recommendationsView.bounds.size.width / 2);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
}


#pragma mark  UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DemoCellIdentifier" forIndexPath:indexPath];
    
    cell.bvProduct = [self.products objectAtIndex:indexPath.row];
    
    return cell;
    
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Selected: %@", [self.products objectAtIndex:indexPath.row]);
    
}

@end
