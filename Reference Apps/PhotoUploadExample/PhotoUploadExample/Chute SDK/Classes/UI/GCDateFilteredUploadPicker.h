//
//  GCDateFilteredUploadPicker.h
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 9/14/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetChute.h"

@interface GCDateFilteredUploadPicker : GCUIBaseViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *images;
    NSArray *filteredImages;
    NSMutableSet *selected;
    IBOutlet UIImageView *selectedIndicator;
    IBOutlet UITableView *imageTable;
    
    IBOutlet UIView *switchModeView;
    IBOutlet UILabel *switchModeLabel;
    
    //selectedSlider is an optional UI component.  In a subclass if you do not initialize the slider in code or hook it up in interface builder the class will still function the same.
    IBOutlet UIScrollView *selectedSlider;
    
    NSArray *uploadChutes;
}
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *filteredImages;
@property (nonatomic, retain) IBOutlet UIImageView *selectedIndicator;
@property (nonatomic, retain) NSArray *uploadChutes;
@property (nonatomic, retain) NSDate *start;
@property (nonatomic, retain) NSDate *end;
@property (nonatomic, retain) NSMutableSet *_selected;
@property (nonatomic, retain) IBOutlet UITableView *imageTable;
@property (nonatomic, retain) IBOutlet UILabel *switchModeLabel;

-(NSArray*)selectedImages;
-(IBAction)uploadAssets:(id)sender;

-(IBAction)switchMode:(id)sender;


//Override in subclass to adjust UI if the filtered images are the same as all the images, or if no filtering is being done.
-(void)hideSwitchView;

@end
