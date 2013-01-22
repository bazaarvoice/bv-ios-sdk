//
//  GCDateFilteredUploadPicker.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 9/14/11.
//  Copyright 2011 Chute Corporation. All rights reserved.
//

#import "GCDateFilteredUploadPicker.h"

@interface GCDateFilteredUploadPicker (Private)
-(UIView*)viewForIndexPath:(NSIndexPath*)indexPath;
-(void)updateSelectedScroller;
@end

@implementation GCDateFilteredUploadPicker
@synthesize selectedIndicator, uploadChutes, start, end, filteredImages, _selected = selected, imageTable, switchModeLabel;

-(void)hideSwitchView{
    [switchModeView setHidden:YES];
    [imageTable setContentInset:UIEdgeInsetsMake(0, 0, imageTable.contentInset.bottom, 0)];
}

-(void)filterArray{
    if(!start &&!end){
        self.filteredImages = self.images;
    }
    else{
        NSMutableArray *array = [NSMutableArray array];
        for(GCAsset *asset in self.images){
            BOOL add = YES;
            if(start && ([[asset createdAt] compare:start] != NSOrderedDescending))
                add = NO;
            if(end && ([[asset createdAt] compare:end] != NSOrderedAscending))
                add = NO;
            if(add)
                [array addObject:asset];
        }
        [self setFilteredImages:array];
    }
    if(self.filteredImages.count == self.images.count){
        [self hideSwitchView];
    }
    else{
        [switchModeLabel setText:[NSString stringWithFormat:@"%i matching Photos.  Click to show all.",self.filteredImages.count]];
    }
}

-(NSArray*)sortArraybyDate:(NSArray*)_array{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_array];
    [array sortUsingComparator:^NSComparisonResult(GCAsset *obj1, GCAsset *obj2){
        NSDate *d1 = [obj1 createdAt];
        NSDate *d2 = [obj2 createdAt];
        if(!d1 || !d2)
            return NSOrderedDescending;
        return [d2 compare:d1];
    }];
    return array;
}

-(void)setImages:(NSArray *)_images{
    if(images){
        [images release];
        images = NULL;
    }
    images = [[NSArray alloc] initWithArray:[self sortArraybyDate:_images]];
}

-(NSArray*)images{
    return images;
}

-(IBAction)switchMode:(id)sender{
    if(!start && !end)
        return;
    if(self.filteredImages.count == self.images.count){
        [self filterArray];
        [switchModeLabel setText:[NSString stringWithFormat:@"%i matching Photos.  Click to show all.",self.filteredImages.count]];
        [imageTable reloadData];
        [sender setSelected:YES];
    }
    else{
        [self setFilteredImages:self.images];
        [switchModeLabel setText:@"Showing all photos.  Click to show filtered Results."];
        [imageTable reloadData];
        [sender setSelected:NO];
    }
    [imageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)objectTappedWithGesture:(UIGestureRecognizer*)gesture{
    UIImageView *view = (UIImageView*)[gesture view];
    GCAsset *asset = [[self filteredImages] objectAtIndex:[view tag]];
    if(![selected containsObject:asset]){
        UIImageView *v = [[UIImageView alloc] initWithImage:self.selectedIndicator.image];
        [v setBackgroundColor:[UIColor whiteColor]];
        [v setFrame:CGRectMake(view.frame.size.width-20, view.frame.size.height-20, 20, 20)];
        [view addSubview:v];
        [v release];
        [selected addObject:asset];
    }
    else{
        for(UIImageView *v in view.subviews){
            [v removeFromSuperview];
        }
        [selected removeObject:asset];
        if(view.superview == selectedSlider){
            int row = view.tag/4;
            [imageTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [self updateSelectedScroller];
}

-(NSArray*)selectedImages{
    return [selected allObjects];
}

-(void)updateSelectedScroller{
    if(selectedSlider){
        for(UIView *v in [selectedSlider subviews])
            [v removeFromSuperview];
        [selectedSlider setContentSize: CGSizeMake((selectedSlider.frame.size.height-5)*[selected count]+5, selectedSlider.frame.size.height)];
        CGRect rect = CGRectMake(5, 5, selectedSlider.frame.size.height-10, selectedSlider.frame.size.height-6);
        for(GCAsset *asset in selected){
            UIImageView *iv = [[[UIImageView alloc] initWithFrame:rect] autorelease];
            [iv setImage:[asset thumbnail]];
            [iv setTag:[[self filteredImages] indexOfObject:asset]];
            [iv setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(objectTappedWithGesture:)];
            [iv addGestureRecognizer:tap];
            [tap release];
            [selectedSlider addSubview:iv];
            rect = CGRectMake(rect.origin.x+rect.size.width+5, rect.origin.y, rect.size.width, rect.size.height);
        }
    }
}

-(void)resetView{
    [selected release];
    selected = [[NSMutableSet alloc] init];
    if(filteredImages && filteredImages.count > 0)
        [imageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [imageTable reloadData];
    [self hideHUD];
    [self updateSelectedScroller];
}

-(IBAction)uploadAssets:(id)sender{
    GCParcel *parcel = [GCParcel objectWithAssets:[self selectedImages] andChutes:[self uploadChutes]];
    [[GCUploader sharedUploader] addParcel:parcel];
    [self showHUDWithTitle:@"Uploading Assets" andOpacity:.5];
    [self performSelector:@selector(resetView) withObject:NULL afterDelay:.5];
}

-(id)init{
    self = [super init];
    if (self) {
        self.start = NULL;
        self.end = NULL;
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.start = NULL;
        self.end = NULL;
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadImagesWithCompletionBlock:(GCBasicBlock)responseBlock{
    NSMutableSet *set = [NSMutableSet set];
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result != NULL){
            GCAsset *asset = [[GCAsset alloc] init];
            [asset setAlAsset:result];
            [set addObject:asset];
            [asset release];
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if(group != nil) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
        }
        else{
            [self setImages:[set allObjects]];
            responseBlock();
        }
    };
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:assetGroupEnumerator
                         failureBlock: ^(NSError *error) {
                         }];
    [library release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [imageTable setAllowsSelection:NO];
    [imageTable setDelegate:self];
    [imageTable setDataSource:self];
    [imageTable setBackgroundColor:[UIColor clearColor]];
    [imageTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    selected = [[NSMutableSet alloc] init];
    if(!selectedIndicator){
        UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIGraphicsBeginImageContext(CGSizeMake(20, 20));
        [[UIColor greenColor] setFill];
        [[UIColor blackColor] setStroke];
        [@"\u2713" drawInRect:temp.frame withFont:[UIFont systemFontOfSize:20]];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [temp setImage:image];
        [temp setBackgroundColor:[UIColor whiteColor]];
        [self setSelectedIndicator:temp];
        [temp release];
    }
    if(!self.images){
        [self showHUDWithTitle:@"loading photos" andOpacity:.5];
        [self loadImagesWithCompletionBlock:^(void){
            [self hideHUD];
            [self filterArray];
            [imageTable reloadData];
        }];
    }
    else{
        [self filterArray];
        [imageTable reloadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [selected release];
    [super dealloc];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(!self.filteredImages)
		return 0;
    return ceil([self.filteredImages count]/4.0);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    for(UIView *v in cell.contentView.subviews){
        [v removeFromSuperview];
    }
	[cell.contentView addSubview:[self viewForIndexPath:indexPath]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 82;
}

-(UIView*)viewForIndexPath:(NSIndexPath*)indexPath{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageTable.frame.size.width, [self tableView:imageTable heightForRowAtIndexPath:indexPath])];
    int index = indexPath.row * 4;
	int maxIndex = index + 3;
    CGRect rect = CGRectMake(3, 1, 77, 77);
    int x = 4;
    if (maxIndex >= [[self filteredImages] count]) {
        x = x - (maxIndex - [[self filteredImages] count]) - 1;
    }
    
    for (int i=0; i<x; i++) {
        GCAsset *asset = [[self filteredImages] objectAtIndex:index+i];
        UIImageView *image = [[[UIImageView alloc] initWithFrame:rect] autorelease];
        [image setTag:index+i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(objectTappedWithGesture:)];
        [image addGestureRecognizer:tap];
        [tap release];
        [image setUserInteractionEnabled:YES];
        [image setImage:[asset thumbnail]];
        if([selected containsObject:asset]){
            UIImageView *v = [[UIImageView alloc] initWithImage:self.selectedIndicator.image];
            [v setBackgroundColor:[UIColor whiteColor]];
            [v setFrame:CGRectMake(image.frame.size.width-20, image.frame.size.height-20, 20, 20)];
            [image addSubview:v];
            [v release];
        }
        [view addSubview:image];
        rect = CGRectMake((rect.origin.x+79), rect.origin.y, rect.size.width, rect.size.height);
    }
    return [view autorelease];
}

@end
