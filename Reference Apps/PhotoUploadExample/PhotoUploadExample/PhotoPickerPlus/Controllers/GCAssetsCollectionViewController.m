//
//  AssetsCollectionViewController.m
//  GCAPIv2TestApp
//
//  Created by Chute Corporation on 7/25/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCAssetsCollectionViewController.h"
#import "PhotoCell.h"
#import "GCAccountAssets.h"
#import "GCServiceAccount.h"
#import "NSDictionary+ALAsset.h"
#import "NSDictionary+GCAccountAsset.h"

#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <Chute-SDK/GCAsset.h>

@interface GCAssetsCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *selectedAssets;

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation GCAssetsCollectionViewController

@synthesize doneButton;
@synthesize successBlock, cancelBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (UICollectionViewFlowLayout *)setupLayout
{
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aFlowLayout setItemSize:CGSizeMake(73.75, 73.75)];
    [aFlowLayout setMinimumInteritemSpacing:0.0f];
    [aFlowLayout setMinimumLineSpacing:5];
    [aFlowLayout setSectionInset:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    return aFlowLayout;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Assets";
    if(self.isMultipleSelectionEnabled)
        [self.navigationItem setRightBarButtonItems:[self doneAndCancelButtons]];
    else
        [self.navigationItem setRightBarButtonItem:[self cancelButton]];
    
    self.selectedAssets = [@[] mutableCopy];

    if(self.isItDevice)
        [self getLocalAssets];
    
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView DataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}

-(PhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(self.isItDevice)
    {
        ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    }
    else
    {
        GCAccountAssets *asset = [self.assets objectAtIndex:indexPath.row];
       AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[asset thumbnail]]] success:^(UIImage *image) {
            [cell.imageView setImage:image];
       }];
        [operation start];
    }

    return cell;
}

#pragma mark - CollectionView Delegate Methods

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isItDevice])
    {
        ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
        [self.selectedAssets addObject:asset];
    }
    else
    {
        GCAccountAssets *asset = [self.assets objectAtIndex:indexPath.row];
        [self.selectedAssets addObject:asset];
    }
    
    if(self.isMultipleSelectionEnabled)
    {
        [self.collectionView setAllowsMultipleSelection:YES];
        
        if([self.selectedAssets count] > 0)
            [self.doneButton setEnabled:YES];
    }
    else
    {
        [self done];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isMultipleSelectionEnabled)
    {        
        if([self isItDevice])
        {
            ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
            [self.selectedAssets removeObject:asset];
        }
        else
        {
            GCAccountAssets *asset = [self.assets objectAtIndex:indexPath.row];
            [self.selectedAssets removeObject:asset];
        }
        
        if([self.selectedAssets count] == 0)
            [self.doneButton setEnabled:NO];
    }
}

#pragma mark - Custom Methods

- (void)getLocalAssets
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result !=nil){
            [temp insertObject:result atIndex:0];
        }
        else
        {
            [self setAssets:temp];
            [self.collectionView reloadData];
        }
        
    }];
}

- (UIBarButtonItem *)cancelButton
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    return cancelButton;
}

- (NSArray *)doneAndCancelButtons
{    
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    [self.doneButton setEnabled:NO];
    
    NSArray *navBarItemsToBeAdd = @[[self doneButton], [self cancelButton]];

    return navBarItemsToBeAdd;
}

#pragma mark - Instance Methods

- (void)done
{
    if (self.successBlock) {
        
        __block id info;
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:HUD];
        [HUD show:YES];
        
        if ([self isMultipleSelectionEnabled]) {
            
            NSMutableArray *infoArray = [NSMutableArray array];
            if(self.isItDevice){
                for (ALAsset *asset in self.selectedAssets) {
                    [infoArray addObject:([NSDictionary infoFromALAsset:asset])];
                }
                info = infoArray;
                [HUD hide:YES];
                [self successBlock](info);
            }
            else
            {
                [GCServiceAccount postSelectedImages:self.selectedAssets success:^(GCResponseStatus *responseStatus, NSArray *returnedArray) {
                    for(GCAsset *asset in returnedArray){
                        [infoArray addObject:([NSDictionary infoFromGCAsset:asset])];
                    }
                    info = infoArray;
                    [HUD hide:YES];
                    [self successBlock](info);
                } failure:^(NSError *error) {
                    [HUD hide:YES];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops! Something went wrong. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	                }];
            }
            
        }
        else {
            if(self.isItDevice)
            {
                info = [NSDictionary infoFromALAsset:[self.selectedAssets objectAtIndex:0]];
                [HUD hide:YES];
                [self successBlock](info);
            }
            else
            {
                [GCServiceAccount postSelectedImages:self.selectedAssets success:^(GCResponseStatus *responseStatus, NSArray *returnedArray) {
                    info = [NSDictionary infoFromGCAsset:[returnedArray objectAtIndex:0]];
                    [HUD hide:YES];
                    [self successBlock](info);
                } failure:^(NSError *error) {
                    [HUD hide:YES];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops! Something went wrong. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }];
                
            }
        }
    }
}

- (void)cancel
{
    if (self.cancelBlock)
        [self cancelBlock]();
}

#pragma mark - Setters

- (void)setIsMultipleSelectionEnabled:(BOOL)isMultipleSelectionEnabled
{
    if(_isMultipleSelectionEnabled != isMultipleSelectionEnabled)
        _isMultipleSelectionEnabled = isMultipleSelectionEnabled;
}

- (void)setIsItDevice:(BOOL)isItDevice
{
    if(_isItDevice != isItDevice)
        _isItDevice = isItDevice;
}

- (void)setAccountID:(NSNumber *)accountID
{
    if(_accountID != accountID)
        _accountID = accountID;
}

- (void)setAlbumID:(NSNumber *)albumID
{
    if(_albumID != albumID)
        _albumID = albumID;
}

- (void)setServiceName:(NSString *)serviceName
{
    if(_serviceName != serviceName)
        _serviceName = serviceName;
}
@end
