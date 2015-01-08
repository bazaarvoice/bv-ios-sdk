//
//  SearchViewController.h
//  BrowseProductsExample
//
//  Created by Bazaarvoice Engineering on 4/26/12.
//  Copyright (c) 2012 Bazaarvoice. All rights reserved.
//
//  UIViewController for prompting the user for a search term
// 

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

//  Search box to enter search term
@property (weak, nonatomic) IBOutlet UITextField *searchBox;

@end
