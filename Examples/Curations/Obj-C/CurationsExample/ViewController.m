//
//  ViewController.m
//  CurationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"
#import "ViewController.h"
#import "DemoCollectionViewCell.h"
#import <CoreLocation/CoreLocation.h>
@import BVSDK;

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet BVCurationsCollectionView *curationsCollectionView;
@property (strong, nonatomic) NSArray<BVCurationsFeedItem *> *curationsFeedItems;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property bool hasRequestedCurations;

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
    
    // create a location manager to get the user's current location, to personalize their curations content based on location
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.curationsCollectionView.collectionViewLayout;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(self.curationsCollectionView.bounds.size.width / 2, self.curationsCollectionView.bounds.size.width / 2);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
}

- (void)fetchCurationsWithLocation:(CLLocation*)location {
    
    // only request curations content once for this demo view controller.
    if (self.hasRequestedCurations == false) {
        self.hasRequestedCurations = true;
    }
    else {
        return;
    }
    
    // Create the request parameters
    NSArray *groups = @[@"__all__"];
    BVCurationsFeedRequest *feedRequest = [[BVCurationsFeedRequest alloc] initWithGroups:groups];
    feedRequest.limit = 40;
    feedRequest.hasPhoto = YES;
    feedRequest.withProductData = YES;
    
    // request curations data, taking the user's location into account
    if (location != nil) {
        [feedRequest setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    }
    
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

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if ([locations count] > 0) {

        CLLocation* location = [locations objectAtIndex:[locations count] - 1];
        
        // Fetching curations data, using user's location
        [self fetchCurationsWithLocation:location];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"error: %@", error);
    
    // Fetching curations data without user's location
    [self fetchCurationsWithLocation:nil];
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        // Fetching curations data without user's location, because we don't have location permission
        [self fetchCurationsWithLocation:nil];
    }
    
}

@end
