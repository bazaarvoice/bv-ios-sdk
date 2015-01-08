//
//  PhotoPickerViewController.m
//  PhotoPickerPlus-SampleApp
//
//  Created by Aleksandar Trpeski on 8/10/13.
//  Copyright (c) 2013 Chute. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "GCPhotoPickerViewController.h"
#import <Chute-SDK/GCOAuth2Client.h>
#import "GCConfiguration.h"

@interface PhotoPickerViewController ()

@property (strong, nonatomic) GCPhotoPickerViewController *photoPickerViewController;

@end

@implementation PhotoPickerViewController

@synthesize photoPickerViewController;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.photoPickerViewController = [GCPhotoPickerViewController new];
        NSDictionary *oauthData = [[GCConfiguration configuration] oauthData];
        [self.photoPickerViewController setOauth2Client:[GCOAuth2Client clientWithClientID:[oauthData objectForKey:kGCClientID] clientSecret:[oauthData objectForKey:kGCClientSecret]]];
        
//        UIImage *navBarImage = [UIImage imageNamed:@"gradient_blue.png"];
//        [self.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setTintColor:[UIColor colorWithRed:0.2078431 green:0.4862745 blue:0.6117647 alpha:1.0]];

        [self setViewControllers:@[self.photoPickerViewController]];
//        [self setModalInPopover:YES];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDelegate:(id<PhotoPickerViewControllerDelegate,UINavigationControllerDelegate>)delegate
{
    [self.photoPickerViewController setDelegate:delegate];
}

- (id<PhotoPickerViewControllerDelegate,UINavigationControllerDelegate>)delegate
{
    return self.photoPickerViewController.delegate;
}

- (void)setIsMultipleSelectionEnabled:(BOOL)isMultipleSelectionEnabled
{
    [self.photoPickerViewController setIsMultipleSelectionEnabled:isMultipleSelectionEnabled];
}

- (BOOL)isMultipleSelectionEnabled
{
    return self.photoPickerViewController.isMultipleSelectionEnabled;
}

//- (void)setOauth2Client:(GCOAuth2Client *)oauth2Client
//{
//    [self.photoPickerViewController setOauth2Client:oauth2Client];
//}
//
//- (GCOAuth2Client *)oauth2Client
//{
//    return [self.photoPickerViewController oauth2Client];
//}

@end
