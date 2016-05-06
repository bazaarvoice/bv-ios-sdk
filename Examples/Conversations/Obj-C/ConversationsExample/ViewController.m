//
//  ViewController.m
//  ConversationsExample
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadReviewsTapped:(id)sender {
    
    // This is the most minimal of Conversations requests.
    // For fetching Conversations content, such as reviews and questions,
    // explore the other options in the BVGet request object.
    BVGet *request = [[BVGet alloc] initWithType:BVGetTypeReviews];
    [request sendRequestWithDelegate:self];
    
}

#pragma mark BVDelegate

- (void) didReceiveResponse:(NSDictionary *)response forRequest:(id)request {
    NSLog(@"Raw Response: %@", response);
}


@end
