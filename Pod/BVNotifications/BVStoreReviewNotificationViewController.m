//
//  BVStoreReviewNotificationViewController.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//
//


#import "BVStoreReviewNotificationViewController.h"
#import <MapKit/MapKit.h>

@interface BVStoreReviewNotificationViewController () <MKMapViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *constrainingView;
@end

@implementation BVStoreReviewNotificationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _constrainingView = [[UIView alloc]initWithFrame:self.view.bounds];
    _constrainingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_constrainingView];
    [_constrainingView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_constrainingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_constrainingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_constrainingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_constrainingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_constrainingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:215];
    [_constrainingView addConstraint:height];
}

- (void)didReceiveNotification:(UNNotification *)notification {
    MKCoordinateRegion region;
    region.center.latitude = [notification.request.content.userInfo[USER_INFO_LAT] floatValue];
    region.center.longitude = [notification.request.content.userInfo[USER_INFO_LONG] floatValue];
    region.span.latitudeDelta = [notification.request.content.userInfo[USER_INFO_LAT_DELTA] floatValue];
    region.span.latitudeDelta = [notification.request.content.userInfo[USER_INFO_LONG_DELTA] floatValue];
    
    _mapView.region = region;
    MKPointAnnotation *ptAnn = [[MKPointAnnotation alloc]init];
    ptAnn.coordinate = region.center;
    [_mapView addAnnotation: ptAnn];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _mapView = [[MKMapView alloc]initWithFrame:_constrainingView.frame];
    [self.view addSubview:_mapView];
    _mapView.showsPointsOfInterest = YES;
}
@end
