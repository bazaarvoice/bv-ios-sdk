//
//  PhotoPickerPlus.m
//  ChuteSDKDevProject
//
//  Created by Brandon Coston on 1/21/12.
//  Copyright (c) 2012 Chute Corporation. All rights reserved.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "PhotoPickerPlus.h"


/************************************************************************
 *                                                                      *
 *                       Account View Controller                        *
 *                                                                      *
 ************************************************************************/

@implementation AccountViewController
@synthesize delegate, photoAlbums, accounts, accountsTable, accountIndex, multipleImageSelectionEnabled, useStandardDevicePicker, P3;

-(void) dealloc{
    [photoAlbums release];
    [accounts release];
    [accountsTable release];
    [super dealloc];
}

-(void)setAccounts:(NSArray *)_accounts{
    if(!_accounts){
        if(accounts){
            [accounts release];
            accounts = NULL;
        }
        return;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for(NSDictionary *dict in _accounts){
        if([[dict objectForKey:@"type"] caseInsensitiveCompare:@"custom"] != NSOrderedSame)
            [temp addObject:dict];
    }
    if(accounts){
        [accounts release];
        accounts = NULL;
    }
    accounts = [temp retain];
}

- (NSString *) pathForCachedUrl:(NSString *)urlString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    
    return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], [urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
}

-(void) closeSelected{
    if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
        [delegate PhotoPickerPlusControllerDidCancel:[self P3]];
}

-(void)accountLoginStatusChangedWithNotification:(NSNotification*)notification{
    if([[GCAccount sharedManager] accountStatus] == GCAccountLoggedIn){
        [self showHUD];
        [[GCAccount sharedManager] loadAccountsInBackgroundWithCompletion:^(void){
            [self setAccounts:[[GCAccount sharedManager] accounts]];
            [[self accountsTable] reloadData];
            if([self accountIndex] >= 0){
                int count = 0;
                if([self photoAlbums])
                    count += [[self photoAlbums] count];
                NSString *type = [ADD_SERVICES_ARRAY_LINKS objectAtIndex:[self accountIndex] - count];
                NSDictionary *account = NULL;
                if([self accounts]){
                    for(NSDictionary *dict in [self accounts]){
                        if([[dict objectForKey:@"type"] caseInsensitiveCompare:type] == NSOrderedSame)
                            account = dict;
                    }
                }
                if(account){
                    if([[account objectForKey:@"type"] caseInsensitiveCompare:@"instagram"] == NSOrderedSame){
                        PhotoViewController *temp = [[PhotoViewController alloc] init];
                        [temp setTitle:@"Instagram"];
                        [temp setDelegate:[self delegate]];
                        [temp setP3:[self P3]];
                        [temp setAccount:account];
                        [temp setMultipleImageSelectionEnabled:[self multipleImageSelectionEnabled]];
                        [temp setUseStandardDevicePicker:[self useStandardDevicePicker]];
                        [self.navigationController pushViewController:temp animated:YES];
                        return;
                    }
                    AlbumViewController *temp = [[AlbumViewController alloc] init];
                    [temp setDelegate:[self delegate]];
                    [temp setTitle:[account objectForKey:@"type"]];
                    [temp setP3:[self P3]];
                    [temp setMultipleImageSelectionEnabled:[self multipleImageSelectionEnabled]];
                    [temp setUseStandardDevicePicker:[self useStandardDevicePicker]];
                    [temp setAccount:account];
                    [self.navigationController pushViewController:temp animated:YES];
                    [temp release];
                }
            }
            [self hideHUD];
        }];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if([self multipleImageSelectionEnabled]){
        if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingArrayOfMediaWithInfo:)])
            [delegate PhotoPickerPlusController:[self P3] didFinishPickingArrayOfMediaWithInfo:[NSArray arrayWithObject:info]];
        else if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingMediaWithInfo:)])
            [delegate PhotoPickerPlusController:[self P3] didFinishPickingMediaWithInfo:info];
    }
    else{
        if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingMediaWithInfo:)])
            [delegate PhotoPickerPlusController:[self P3] didFinishPickingMediaWithInfo:info];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
        [delegate PhotoPickerPlusControllerDidCancel:[self P3]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.accounts = [[GCAccount sharedManager] accounts];
    self.accountsTable = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    if([self.navigationController.navigationBar isTranslucent]){
        [self.accountsTable setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0, 0, 0)];
    }
    [accountsTable setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [accountsTable setDelegate:self];
    [accountsTable setDataSource:self];
    [self.view addSubview:accountsTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountLoginStatusChangedWithNotification:) name:GCAccountStatusChanged object:nil];
    UIBarButtonItem *rightPhotoButton;
    rightPhotoButton = [[UIBarButtonItem alloc] initWithTitle:CANCEL_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(closeSelected)];
    [self.navigationItem setRightBarButtonItem:rightPhotoButton];
    [rightPhotoButton release];
    [self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:BACK_BUTTON_TEXT style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    if(![self useStandardDevicePicker]){
        NSMutableArray *array = [NSMutableArray array];
        [self setAccountIndex:-1];
        
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group == nil) {
                [self setPhotoAlbums:array];
                [self.accountsTable reloadData];
            }
            else{
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                if([group numberOfAssets]> 0)
                    [array insertObject:group atIndex:0];
            }
        };
        
        void (^assetFailureBlock)(NSError *) = ^(NSError *error)
        {
            [self setPhotoAlbums:NULL];
        };
        
        if(![[GCAccount sharedManager] assetsLibrary]){
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [[GCAccount sharedManager] setAssetsLibrary:library];
            [library release];
        }
        [[[GCAccount sharedManager] assetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetFailureBlock];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(UIView*)tableView:(UITableView *)tableView viewForIndexPath:(NSIndexPath*)indexPath{
    return nil;
}


#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self useStandardDevicePicker])
        return [ADD_SERVICES_ARRAY_NAMES count]+1;
    int count = 0;
    if([self photoAlbums])
        count += [[self photoAlbums] count];
    count += [ADD_SERVICES_ARRAY_NAMES count];
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setText:@" "];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        UIView *v = [self tableView:tableView viewForIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(v){
                for(UIView *view in cell.contentView.subviews){
                    [view removeFromSuperview];
                }
                [cell.contentView addSubview:v];
            }
            else{
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                if([self useStandardDevicePicker]){
                    if(indexPath.row == 0){
                        [cell.imageView setImage:[UIImage imageNamed:@"GCNAIblank.png"]];
                        [cell.textLabel setText:USE_DEVICE_TITLE];
                    }
                    else{
                        NSString *imageName = [[NSString stringWithFormat:@"%@.png",[ADD_SERVICES_ARRAY_NAMES objectAtIndex:indexPath.row - 1]] lowercaseString];
                        UIImage *temp = [UIImage imageNamed:imageName];
                        [cell.imageView setImage:temp];
                        [cell.textLabel setText:[ADD_SERVICES_ARRAY_NAMES objectAtIndex:indexPath.row - 1]];
                        NSString *type = [ADD_SERVICES_ARRAY_LINKS objectAtIndex:indexPath.row - 1];
                        NSDictionary *account = NULL;
                        if([self accounts]){
                            for(NSDictionary *dict in [self accounts]){
                                if([[dict objectForKey:@"type"] caseInsensitiveCompare:type] == NSOrderedSame)
                                    account = dict;
                            }
                        }
                        if(account){
                            if([[NSString stringWithFormat:@"%@",[account objectForKey:@"name"]] caseInsensitiveCompare:@"(null)"] != NSOrderedSame)
                                [cell.textLabel setText:[account objectForKey:@"name"]];
                        }
                    }
                }
                else{
                    int count = 0;
                    if([self photoAlbums])
                        count += [[self photoAlbums] count];
                    if(indexPath.row >= count){
                        NSString *imageName = [[NSString stringWithFormat:@"%@.png",[ADD_SERVICES_ARRAY_NAMES objectAtIndex:indexPath.row - count]] lowercaseString];
                        UIImage *temp = [UIImage imageNamed:imageName];
                        [cell.imageView setImage:temp];
                        [cell.textLabel setText:[ADD_SERVICES_ARRAY_NAMES objectAtIndex:indexPath.row - count]];
                        NSString *type = [ADD_SERVICES_ARRAY_LINKS objectAtIndex:indexPath.row - count];
                        NSDictionary *account = NULL;
                        if([self accounts]){
                            for(NSDictionary *dict in [self accounts]){
                                if([[dict objectForKey:@"type"] caseInsensitiveCompare:type] == NSOrderedSame)
                                    account = dict;
                            }
                        }
                        if(account){
                            if([[NSString stringWithFormat:@"%@",[account objectForKey:@"name"]] caseInsensitiveCompare:@"(null)"] != NSOrderedSame)
                                [cell.textLabel setText:[account objectForKey:@"name"]];
                        }
                    }
                    else{
                        ALAssetsGroup *group = [self.photoAlbums objectAtIndex:indexPath.row];
                        [cell.textLabel setText:[group valueForProperty:ALAssetsGroupPropertyName]];
                        [cell.imageView setImage:[UIImage imageWithCGImage:[group posterImage]]];
                    }
                }
            }
        });
    });
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == accountsTable){
        if([self useStandardDevicePicker] && indexPath.row == 0){ 
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//            [picker setMediaTypes:[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]];
            [picker setDelegate:self];
            [self presentViewController:picker animated:YES completion:^(void){
                [picker release];
            }];
            return;
        }
        [self setAccountIndex:indexPath.row];
        int count = 0;
        if([self photoAlbums])
            count += [[self photoAlbums] count];
        if([self useStandardDevicePicker])
            count = 1;
        if(indexPath.row >= count){
            NSString *type = [ADD_SERVICES_ARRAY_LINKS objectAtIndex:indexPath.row - count];
            NSString *albumTitle = [ADD_SERVICES_ARRAY_NAMES objectAtIndex:indexPath.row - count];
            NSDictionary *account = NULL;
            if([self accounts]){
                for(NSDictionary *dict in [self accounts]){
                    if([[dict objectForKey:@"type"] caseInsensitiveCompare:type] == NSOrderedSame)
                        account = dict;
                }
            }
            if(account){
                if([[account objectForKey:@"type"] caseInsensitiveCompare:@"instagram"] == NSOrderedSame){
                    PhotoViewController *temp = [[PhotoViewController alloc] init];
                    [temp setTitle:albumTitle];
                    [temp setDelegate:[self delegate]];
                    [temp setTitle:@"Instagram"];
                    [temp setP3:[self P3]];
                    [temp setAccount:account];
                    [temp setMultipleImageSelectionEnabled:[self multipleImageSelectionEnabled]];
                    [temp setUseStandardDevicePicker:[self useStandardDevicePicker]];
                    [self.navigationController pushViewController:temp animated:YES];
                    return;
                }
                AlbumViewController *temp = [[AlbumViewController alloc] init];
                [temp setDelegate:[self delegate]];
                [temp setTitle:[account objectForKey:@"type"]];
                [temp setP3:[self P3]];
                [temp setMultipleImageSelectionEnabled:[self multipleImageSelectionEnabled]];
                [temp setUseStandardDevicePicker:[self useStandardDevicePicker]];
                [temp setAccount:account];
                [self.navigationController pushViewController:temp animated:YES];
                [temp release];
            }
            else{
                AccountLoginViewController *temp = [[AccountLoginViewController alloc] init];
                [temp setService:type];
                [self.navigationController pushViewController:temp animated:YES];
                [temp release];
            }
        }
        else{
            ALAssetsGroup *group = [self.photoAlbums objectAtIndex:indexPath.row];
            PhotoViewController *temp = [[PhotoViewController alloc] init];
            [temp setTitle:[group valueForProperty:ALAssetsGroupPropertyName]];
            [temp setDelegate:[self delegate]];
            [temp setP3:[self P3]];
            [temp setAccount:NULL];
            [temp setGroup:group];
            [temp setMultipleImageSelectionEnabled:[self multipleImageSelectionEnabled]];
            [temp setUseStandardDevicePicker:[self useStandardDevicePicker]];
            [self.navigationController pushViewController:temp animated:YES];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end


/************************************************************************
 *                                                                      *
 *                    Account Login View Controller                     *
 *                                                                      *
 ************************************************************************/

@implementation AccountLoginViewController
@synthesize AddServiceWebView, service;

-(void)dealloc{
    [AddServiceWebView release];
    [service release];
    [super dealloc];
}

#pragma mark WebView Delegate Methods

-(void)viewDidLoad{
    self.AddServiceWebView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    [AddServiceWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [AddServiceWebView setDelegate:self];
    [self.view addSubview:AddServiceWebView];
    
    if([self service]){
        NSDictionary *params = [NSMutableDictionary new];
        [params setValue:@"profile" forKey:@"scope"];
        [params setValue:@"web_server" forKey:@"type"];
        [params setValue:@"code" forKey:@"response_type"];
        [params setValue:kOAuthAppID forKey:@"client_id"];
        [params setValue:kOAuthCallbackURL forKey:@"redirect_uri"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/%@?%@", 
                                                                                   SERVER_URL,
                                                                                   self.service,
                                                                                   [params stringWithFormEncodedComponents]]]];
        [AddServiceWebView sizeToFit];
        [AddServiceWebView loadRequest:request];
        [params release];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
}

-(void)viewWillUnload{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] path] isEqualToString:kOAuthCallbackRelativeURL]) {
        NSString *_code = [[NSDictionary dictionaryWithFormEncodedString:[[request URL] query]] objectForKey:@"code"];
        
        [[GCAccount sharedManager] verifyAuthorizationWithAccessCode:_code success:^(void) {
            [self.navigationController popViewControllerAnimated:YES];
        } andError:^(NSError *error) {
            DLog(@"%@", [error localizedDescription]);
        }];
        
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHUDWithTitle:nil andOpacity:0.3f];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideHUD];
    
    if (error.code == NSURLErrorCancelled) return; 
    
    if (![[error localizedDescription] isEqualToString:@"Frame load interrupted"]) {
        [self quickAlertViewWithTitle:@"Error" message:[error localizedDescription] button:@"Reload" completionBlock:^(void) {
            [AddServiceWebView reload]; 
        } cancelBlock:^(void) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end


/************************************************************************
 *                                                                      *
 *                        Album View Controller                         *
 *                                                                      *
 ************************************************************************/

@implementation AlbumViewController
@synthesize delegate, albums, albumsTable, multipleImageSelectionEnabled, useStandardDevicePicker, account, P3;

-(void)dealloc{
    [albums release];
    [albumsTable release];
    [super dealloc];
}

-(void) closeSelected{
    if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
        [delegate PhotoPickerPlusControllerDidCancel:[self P3]];
}

- (NSString *) pathForCachedUrl:(NSString *)urlString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    
    return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], [urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
}

-(void)viewDidLoad{
    
    self.albumsTable = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    if([self.navigationController.navigationBar isTranslucent]){
        [self.albumsTable setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0, 0, 0)];
    }
    [albumsTable setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [albumsTable setDelegate:self];
    [albumsTable setDataSource:self];
    [self.view addSubview:albumsTable];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self pathForCachedUrl:[NSString stringWithFormat:@"%@/albums",[account objectForKey:@"accountID"]]];
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"Using cached file!");
        NSError *error = NULL;
        NSString *data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if(!error){
            id result = [data JSONValue];
            if([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"data"])
                result = [result objectForKey:@"data"];
            [self setAlbums:result];
        }
    }
    
    [self showHUD];
    [[GCAccount sharedManager] albumsForAccount:[account objectForKey:@"accountID"] inBackgroundWithResponse:^(GCResponse *response){
        if([response isSuccessful]){
            [self setAlbums:[response object]];
            [albumsTable reloadData];
        }
        [self hideHUD];
    }];
    UIBarButtonItem *rightPhotoButton;
    rightPhotoButton = [[UIBarButtonItem alloc] initWithTitle:CANCEL_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(closeSelected)];
    [self.navigationItem setRightBarButtonItem:rightPhotoButton];
    [rightPhotoButton release];
    [self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:BACK_BUTTON_TEXT style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!albums)
        return 0;
    return [albums count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setText:@" "];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        UIView *v = [self tableView:tableView viewForIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(v){
                for(UIView *view in cell.contentView.subviews){
                    [view removeFromSuperview];
                }
                [cell.contentView addSubview:v];
            }
            else{
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                [cell.textLabel setText:[[[self albums] objectAtIndex:indexPath.row] objectForKey:@"name"]];
            }
        });
    });
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(account){
        PhotoViewController *temp = [[PhotoViewController alloc] init];
        [temp setTitle:[[[self albums] objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [temp setDelegate:[self delegate]];
        [temp setP3:[self P3]];
        [temp setAccount:account];
        [temp setAlbum:[albums objectAtIndex:indexPath.row]];
        [temp setMultipleImageSelectionEnabled:[self multipleImageSelectionEnabled]];
        [temp setUseStandardDevicePicker:[self useStandardDevicePicker]];
        [self.navigationController pushViewController:temp animated:YES];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForIndexPath:(NSIndexPath*)indexPath{
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end


/************************************************************************
 *                                                                      *
 *                        Photo View Controller                         *
 *                                                                      *
 ************************************************************************/

@implementation PhotoViewController
@synthesize  delegate, photos, photosTable, photoCountView, photoCountLabel, selectedAssets, multipleImageSelectionEnabled, useStandardDevicePicker, account, P3, album, group;

-(void)dealloc{
    [photos release];
    [photosTable release];
    [selectedAssets release];
    [photoCountView release];
    [photoCountLabel release];
    [super dealloc];
}

- (NSString *) pathForCachedUrl:(NSString *)urlString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    
    return [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], [urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
}

-(void)objectTappedWithGesture:(UIGestureRecognizer*)gesture{
    UIImageView *view = (UIImageView*)[gesture view];
    if([self multipleImageSelectionEnabled]){
        id asset = [[self photos] objectAtIndex:view.tag];
        if(![[self selectedAssets] containsObject:asset]){
            UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectionIndicator.png"]];
            [v setBackgroundColor:[UIColor clearColor]];
            [v setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            [view addSubview:v];
            [v release];
            [[self selectedAssets] addObject:asset];
        }
        else{
            for(UIImageView *v in view.subviews){
                [v removeFromSuperview];
            }
            [[self selectedAssets] removeObject:asset];
        }
    }
    else{
        [self showHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            id object = [[self photos] objectAtIndex:[view tag]];
            if([object isKindOfClass:[GCAsset class]]){
                ALAsset *asset = [object alAsset];
                NSMutableDictionary* temp = [NSMutableDictionary dictionary];
                [temp setObject:[[asset defaultRepresentation] UTI] forKey:UIImagePickerControllerMediaType];
                [temp setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage] scale:1 orientation:(UIImageOrientation)[[asset defaultRepresentation] orientation]] forKey:UIImagePickerControllerOriginalImage];
                [temp setObject:[[asset defaultRepresentation] url] forKey:UIImagePickerControllerReferenceURL];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingMediaWithInfo:)])
                        [delegate PhotoPickerPlusController:[self P3] didFinishPickingMediaWithInfo:temp];
                    [self hideHUD];
                });
            }
            else{
                NSMutableDictionary *asset = [NSMutableDictionary dictionaryWithDictionary:object];
                [asset setObject:account forKey:@"source"];
                NSData *data = NULL;
                if([[NSString stringWithFormat:@"%@",[asset objectForKey:@"url"]] caseInsensitiveCompare:@"<null>"] != NSOrderedSame)
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[asset objectForKey:@"url"]]];
                else{
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[asset objectForKey:@"thumb"]]];
                }
                UIImage *image = [UIImage imageWithData:data];
                NSMutableDictionary* temp = [NSMutableDictionary dictionary];
                [temp setObject:@"public.image" forKey:UIImagePickerControllerMediaType];
                if(image)
                    [temp setObject:image forKey:UIImagePickerControllerOriginalImage];
                else{
                    [temp setObject:view.image forKey:UIImagePickerControllerOriginalImage];
                }
                if([[NSString stringWithFormat:@"%@",[asset objectForKey:@"url"]] caseInsensitiveCompare:@"<null>"] != NSOrderedSame)
                    [temp setObject:[NSURL URLWithString:[asset objectForKey:@"url"]] forKey:UIImagePickerControllerReferenceURL];
                else{
                    [temp setObject:[NSURL URLWithString:[asset objectForKey:@"thumb"]] forKey:UIImagePickerControllerReferenceURL];
                }
                [temp setObject:asset forKey:UIImagePickerControllerMediaMetadata];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingMediaWithInfo:)])
                        [delegate PhotoPickerPlusController:[self P3] didFinishPickingMediaWithInfo:temp];
                    [self hideHUD];
                });
            }
        });
    }
}

-(void) closeSelected{
    if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
        [delegate PhotoPickerPlusControllerDidCancel:[self P3]];
}

-(void)doneSelected{
    NSMutableArray *returnArray = [NSMutableArray array];
    [self showHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        for(id object in [self selectedAssets]){
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            if([object isKindOfClass:[GCAsset class]]){
                ALAsset *asset = [object alAsset];
                NSMutableDictionary* temp = [NSMutableDictionary dictionary];
                [temp setObject:[[asset defaultRepresentation] UTI] forKey:UIImagePickerControllerMediaType];
                [temp setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1 orientation:(UIImageOrientation)[[asset defaultRepresentation] orientation]] forKey:UIImagePickerControllerOriginalImage];
                [temp setObject:[[asset defaultRepresentation] url] forKey:UIImagePickerControllerReferenceURL];
                [returnArray addObject:temp];
            }
            else{
                NSMutableDictionary *asset = [NSMutableDictionary dictionaryWithDictionary:object];
                [asset setObject:account forKey:@"source"];
                NSData *data = NULL;
                if([[NSString stringWithFormat:@"%@",[asset objectForKey:@"url"]] caseInsensitiveCompare:@"<null>"] != NSOrderedSame)
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[asset objectForKey:@"url"]]];
                else{
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[asset objectForKey:@"thumb"]]];
                }
                UIImage *image = [UIImage imageWithData:data];
                NSMutableDictionary* temp = [NSMutableDictionary dictionary];
                [temp setObject:@"public.image" forKey:UIImagePickerControllerMediaType];
                if(image)
                    [temp setObject:image forKey:UIImagePickerControllerOriginalImage];
                if([[NSString stringWithFormat:@"%@",[asset objectForKey:@"url"]] caseInsensitiveCompare:@"<null>"] != NSOrderedSame)
                    [temp setObject:[NSURL URLWithString:[asset objectForKey:@"url"]] forKey:UIImagePickerControllerReferenceURL];
                else{
                    [temp setObject:[NSURL URLWithString:[asset objectForKey:@"thumb"]] forKey:UIImagePickerControllerReferenceURL];
                }
                [temp setObject:asset forKey:UIImagePickerControllerMediaMetadata];
                [returnArray addObject:temp];
            }
            [pool release];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingArrayOfMediaWithInfo:)])
                [delegate PhotoPickerPlusController:[self P3] didFinishPickingArrayOfMediaWithInfo:returnArray];
            [self hideHUD];
        });
    });
}

-(IBAction)hidePhotoCountView{
    [[self photoCountLabel] setText:@""];
    [[self photoCountView] removeFromSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePhotoCountView) object:nil];
}

-(void)showPhotoCountViewWithCount:(int)photoCount{
    [[self photoCountLabel] setText:[NSString stringWithFormat:PHOTO_COUNT_FORMAT, photoCount]];
    [photoCountView setFrame:self.view.bounds];
    [self.view addSubview:[self photoCountView]];
    [self performSelector:@selector(hidePhotoCountView) withObject:nil afterDelay:messageTime];
}

-(void)viewDidLoad{
    
    self.selectedAssets = [NSMutableOrderedSet orderedSet];
    
    self.photosTable = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    if([self.navigationController.navigationBar isTranslucent]){
        [self.photosTable setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0, 0, 0)];
    }
    [photosTable setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [photosTable setDelegate:self];
    [photosTable setDataSource:self];
    [photosTable setSeparatorColor:[UIColor clearColor]];
    [photosTable setAllowsSelection:NO];
    [self.view addSubview:photosTable];
    
    self.photoCountView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    [photoCountView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [photoCountView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.4]];
    
    UIButton *closeCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeCountButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [closeCountButton setFrame:photoCountView.frame];
    [closeCountButton addTarget:self action:@selector(hidePhotoCountView) forControlEvents:UIControlEventTouchDown];
    [photoCountView addSubview:closeCountButton];
    
    self.photoCountLabel = [[[UILabel alloc] initWithFrame:self.view.bounds] autorelease];
    [photoCountLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [photoCountLabel setBackgroundColor:[UIColor clearColor]];
    [photoCountLabel setTextColor:[UIColor whiteColor]];
    [photoCountLabel setTextAlignment:UITextAlignmentCenter];
    [photoCountView addSubview:photoCountLabel];
    if(!account){
        if(group){
            [self showHUD];
            
            NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
            
            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
            {
                if(result != nil){
                    GCAsset *_asset = [[GCAsset alloc] init];
                    [_asset setAlAsset:result];
                    [assetsArray insertObject:_asset atIndex:0];
                    [_asset release];
                }
                else{
                    [self setPhotos:assetsArray];
                    [photosTable reloadData];
                    [self showPhotoCountViewWithCount:[[self photos] count]];
                    [self hideHUD];
                }
            };
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
    }
    else if([[account objectForKey:@"type"] caseInsensitiveCompare:@"instagram"] == NSOrderedSame){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [self pathForCachedUrl:[NSString stringWithFormat:@"%@/%@/photos",[account objectForKey:@"accountID"],@""]];
        if ([fileManager fileExistsAtPath:filePath])
        {
            NSLog(@"Using cached file!");
            NSError *error = NULL;
            NSString *data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if(!error){
                id result = [data JSONValue];
                if([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"data"])
                    result = [result objectForKey:@"data"];
                [self setPhotos:result];
            }
        }
        [[GCAccount sharedManager] albumsForAccount:[account objectForKey:@"accountID"] inBackgroundWithResponse:^(GCResponse *response){
            if([response isSuccessful]){
                [[GCAccount sharedManager] photosForAccount:[account objectForKey:@"accountID"] andAlbum:[[[response object] objectAtIndex:0] objectForKey:@"id"] inBackgroundWithResponse:^(GCResponse *response){
                    if([response isSuccessful]){
                        [self setPhotos:[response object]];
                        [photosTable reloadData];
                        [self showPhotoCountViewWithCount:[[self photos] count]];
                        [[response rawResponse] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                    }
                }];
            }
        }];
    }
    else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [self pathForCachedUrl:[NSString stringWithFormat:@"%@/%@/photos",[account objectForKey:@"accountID"],[album objectForKey:@"id"]]];
        if ([fileManager fileExistsAtPath:filePath])
        {
            NSLog(@"Using cached file!");
            NSError *error = NULL;
            NSString *data = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if(!error){
                id result = [data JSONValue];
                if([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"data"])
                    result = [result objectForKey:@"data"];
                [self setPhotos:result];
            }
        }
        [[GCAccount sharedManager] photosForAccount:[account objectForKey:@"accountID"] andAlbum:[album objectForKey:@"id"] inBackgroundWithResponse:^(GCResponse *response){
            if([response isSuccessful]){
                [self setPhotos:[response object]];
                [photosTable reloadData];
                [self showPhotoCountViewWithCount:[[self photos] count]];
                [[response rawResponse] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            }
        }];
    }
    
    UIBarButtonItem *rightPhotoButton;
    if([self multipleImageSelectionEnabled])
        rightPhotoButton = [[UIBarButtonItem alloc] initWithTitle:DONE_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(doneSelected)];
    else
        rightPhotoButton = [[UIBarButtonItem alloc] initWithTitle:CANCEL_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(closeSelected)];
    [self.navigationItem setRightBarButtonItem:rightPhotoButton];
    [rightPhotoButton release];
    [self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:BACK_BUTTON_TEXT style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    return;
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!photos)
        return 0;
    return ceil([photos count]/((float)THUMB_COUNT_PER_ROW));
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setText:@" "];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        UIView *v = [self tableView:tableView viewForIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(v){
                for(UIView *view in cell.contentView.subviews){
                    [view removeFromSuperview];
                }
                [cell.contentView addSubview:v];
            }
            else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
            }
        });
    });
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return THUMB_SPACING + THUMB_SIZE;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView*)tableView:(UITableView *)tableView viewForIndexPath:(NSIndexPath*)indexPath{
    if(tableView == photosTable){
        int initialThumbOffset = ((int)photosTable.frame.size.width+THUMB_SPACING-(THUMB_COUNT_PER_ROW*(THUMB_SIZE+THUMB_SPACING)))/2;
        if([self account]){
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, photosTable.frame.size.width, [self tableView:photosTable heightForRowAtIndexPath:indexPath])] autorelease];
            int index = indexPath.row * (THUMB_COUNT_PER_ROW);
            int maxIndex = index + ((THUMB_COUNT_PER_ROW)-1);
            CGRect rect = CGRectMake(initialThumbOffset, THUMB_SPACING/2, THUMB_SIZE, THUMB_SIZE);
            int x = THUMB_COUNT_PER_ROW;
            if (maxIndex >= [[self photos] count]) {
                x = x - (maxIndex - [[self photos] count]) - 1;
            }
            
            for (int i=0; i<x; i++) {
                NSDictionary *asset = [[self photos] objectAtIndex:index+i];
                UIImageView *image = [[[UIImageView alloc] initWithFrame:rect] autorelease];
                [image setTag:index+i];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(objectTappedWithGesture:)];
                [image addGestureRecognizer:tap];
                [tap release];
                [image setUserInteractionEnabled:YES];
                [image setImageWithURL:[NSURL URLWithString:[asset objectForKey:@"thumb"]]];
                [view addSubview:image];
                if([[self selectedAssets] containsObject:asset]){
                    UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectionIndicator.png"]];
                    [v setBackgroundColor:[UIColor clearColor]];
                    [v setFrame:CGRectMake(0, 0, image.frame.size.width, image.frame.size.height)];
                    [image addSubview:v];
                    [v release];
                }
                rect = CGRectMake((rect.origin.x+THUMB_SIZE+THUMB_SPACING), rect.origin.y, rect.size.width, rect.size.height);
            }
            return view;
        }
        else{
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, photosTable.frame.size.width, [self tableView:photosTable heightForRowAtIndexPath:indexPath])] autorelease];
            int index = indexPath.row * (THUMB_COUNT_PER_ROW);
            int maxIndex = index + ((THUMB_COUNT_PER_ROW)-1);
            CGRect rect = CGRectMake(initialThumbOffset, THUMB_SPACING/2, THUMB_SIZE, THUMB_SIZE);
            int x = THUMB_COUNT_PER_ROW;
            if (maxIndex >= [[self photos] count]) {
                x = x - (maxIndex - [[self photos] count]) - 1;
            }
            
            for (int i=0; i<x; i++) {
                GCAsset *asset = [[self photos] objectAtIndex:index+i];
                UIImageView *image = [[[UIImageView alloc] initWithFrame:rect] autorelease];
                [image setTag:index+i];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(objectTappedWithGesture:)];
                [image addGestureRecognizer:tap];
                [tap release];
                [image setUserInteractionEnabled:YES];
                [image setImage:[asset thumbnail]];
                [view addSubview:image];
                if([[self selectedAssets] containsObject:asset]){
                    UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectionIndicator.png"]];
                    [v setBackgroundColor:[UIColor clearColor]];
                    [v setFrame:CGRectMake(0, 0, image.frame.size.width, image.frame.size.height)];
                    [image addSubview:v];
                    [v release];
                }
                rect = CGRectMake((rect.origin.x+THUMB_SIZE+THUMB_SPACING), rect.origin.y, rect.size.width, rect.size.height);
            }
            return view;
        }
    }
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end


/************************************************************************
 *                                                                      *
 *                          Photo Picker Plus                           *
 *                                                                      *
 ************************************************************************/

@implementation PhotoPickerPlus
@synthesize delegate;
@synthesize appeared, multipleImageSelectionEnabled, useStandardDevicePicker, offerLatestPhoto;
@synthesize sourceType, presentationStyle;


-(void)dealloc{
    [super dealloc];
}

-(IBAction)cameraSelected:(id)sender{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){ 
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:^(void){
            [picker release];
        }];
    }
    else{
        [self quickAlertViewWithTitle:@"Camera Not Available" message:@"Please select a different source type" button:@"OK" completionBlock:^(void){
            if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
                [delegate PhotoPickerPlusControllerDidCancel:self];
        } cancelBlock:nil];
    }
}

-(IBAction)deviceSelected:(id)sender{
    AccountViewController *temp = [[AccountViewController alloc] init];
    [temp setDelegate:self.delegate];
    [temp setTitle:@"Photos"];
    [temp setP3:self];
    [temp setMultipleImageSelectionEnabled:[self multipleImageSelectionEnabled]];
    [temp setUseStandardDevicePicker:[self useStandardDevicePicker]];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:temp] autorelease];
    [navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [navController setModalPresentationStyle:[self presentationStyle]];
    [[GCAccount sharedManager] loadAccountsInBackgroundWithCompletion:^(void){
        [self presentModalViewController:navController animated:YES];
    }];
    [temp release];
}

-(IBAction)latestSelected:(id)sender{
    [self showHUD];
    [[GCAccount sharedManager] loadAssetsCompletionBlock:^(void){
        if([[GCAccount sharedManager] assetsArray].count > 0){
            GCAsset *object = [[[GCAccount sharedManager] assetsArray] objectAtIndex:0];
            ALAsset *asset = [object alAsset];
            NSMutableDictionary* temp = [NSMutableDictionary dictionary];
            [temp setObject:[[asset defaultRepresentation] UTI] forKey:UIImagePickerControllerMediaType];
            [temp setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage] scale:1 orientation:(UIImageOrientation)[[asset defaultRepresentation] orientation]] forKey:UIImagePickerControllerOriginalImage];
            [temp setObject:[[asset defaultRepresentation] url] forKey:UIImagePickerControllerReferenceURL];
            if([self multipleImageSelectionEnabled]){
                if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingArrayOfMediaWithInfo:)])
                    [delegate PhotoPickerPlusController:self didFinishPickingArrayOfMediaWithInfo:[NSArray arrayWithObject:temp]];
            }
            else{
                if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingMediaWithInfo:)])
                    [delegate PhotoPickerPlusController:self didFinishPickingMediaWithInfo:temp];
            }
        }
        else{
            if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
                [delegate PhotoPickerPlusControllerDidCancel:self];
        }
        [self hideHUD];
    } andFailure:^(void){
        if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
            [delegate PhotoPickerPlusControllerDidCancel:self];
    }];
}

-(IBAction)closeSelected:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
        [delegate PhotoPickerPlusControllerDidCancel:self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if([self multipleImageSelectionEnabled]){
        [self dismissViewControllerAnimated:YES completion:^(void){
            if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingArrayOfMediaWithInfo:)])
                [delegate PhotoPickerPlusController:self didFinishPickingArrayOfMediaWithInfo:[NSArray arrayWithObject:info]];
            else if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingMediaWithInfo:)])
                [delegate PhotoPickerPlusController:self didFinishPickingMediaWithInfo:info];
        }];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^(void){
            if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusController:didFinishPickingMediaWithInfo:)])
                [delegate PhotoPickerPlusController:self didFinishPickingMediaWithInfo:info];
        }];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^(void){
        if(delegate && [delegate respondsToSelector:@selector(PhotoPickerPlusControllerDidCancel:)])
            [delegate PhotoPickerPlusControllerDidCancel:self];
        
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setMultipleImageSelectionEnabled:NO];
        [self setSourceType:PhotoPickerPlusSourceTypeAll];
        [self setUseStandardDevicePicker:NO];
        [self setOfferLatestPhoto:YES];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIButton *close = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [close setAlpha:.01];
    [close setFrame:self.view.bounds];
    [close addTarget:self action:@selector(closeSelected:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:close];
    if(!appeared){
        if(sourceType == PhotoPickerPlusSourceTypeAll){
            if([self multipleImageSelectionEnabled]){
                UIActionSheet *popupQuery = nil;
                if([self offerLatestPhoto])
                popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:CANCEL_BUTTON_TEXT destructiveButtonTitle:nil otherButtonTitles:CAMERA_OPTION_TEXT, DEVICE_PLURAL_OPTION_TEXT, LATEST_OPTION_TEXT, nil];
                else
                    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:CANCEL_BUTTON_TEXT destructiveButtonTitle:nil otherButtonTitles:CAMERA_OPTION_TEXT, DEVICE_PLURAL_OPTION_TEXT, nil];
                popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                popupQuery.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
                [popupQuery showInView:self.view];
                [popupQuery release];
            }
            else{
                UIActionSheet *popupQuery = nil;
                if([self offerLatestPhoto])
                    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:CANCEL_BUTTON_TEXT destructiveButtonTitle:nil otherButtonTitles:CAMERA_OPTION_TEXT, DEVICE_SINGLE_OPTION_TEXT, LATEST_OPTION_TEXT, nil];
                else
                    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:CANCEL_BUTTON_TEXT destructiveButtonTitle:nil otherButtonTitles:CAMERA_OPTION_TEXT, DEVICE_SINGLE_OPTION_TEXT, nil];
                popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                popupQuery.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
                [popupQuery showInView:self.view];
                [popupQuery release];
            }
        }else if(sourceType == PhotoPickerPlusSourceTypeCamera){
            [self cameraSelected:nil];
        }else if(sourceType == PhotoPickerPlusSourceTypeLibrary){
            [self deviceSelected:nil];
        }else if(sourceType == PhotoPickerPlusSourceTypeNewestPhoto){
            [self latestSelected:nil];
        }
        appeared = YES;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        [self cameraSelected:nil];
	} else if (buttonIndex == 1) {
        [self deviceSelected:nil];
	} else if (buttonIndex == 2) {
        if([self offerLatestPhoto])
            [self latestSelected:nil];
        else
            [self closeSelected:nil];
	} else if (buttonIndex == 3) {
        [self closeSelected:nil];
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
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}
@end
