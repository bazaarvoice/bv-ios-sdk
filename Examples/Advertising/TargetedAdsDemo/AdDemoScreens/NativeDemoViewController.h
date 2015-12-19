//
//  NativeDemoViewController.h
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BVSDK/BVAdvertising.h>

@interface NativeDemoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property UICollectionView* collectionView;
@property BVTargetedAdLoader* adLoader;

@end
