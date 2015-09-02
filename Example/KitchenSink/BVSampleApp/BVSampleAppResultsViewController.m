//
//  BVSampleAppResultsViewController.m
//  Bazaarvoice SDK - Demo Application
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import "BVSampleAppResultsViewController.h"
#import <BVSDK/BVSDK.h>

@implementation BVSampleAppResultsViewController

- (void)viewDidAppear:(BOOL)animated {

    self.urlResultsView.text = [self prettyJson:self.responseToDisplay];
    
    
    if([self.requestToSend isKindOfClass:[BVPost class]]) {
        self.urlTextView.text = [(BVPost *)self.requestToSend requestURL];
    } else if([self.requestToSend isKindOfClass:[BVGet class]]) {
        self.urlTextView.text = [(BVGet *)self.requestToSend requestURL];
    } else if([self.requestToSend isKindOfClass:[BVMediaPost class]]) {
        self.urlTextView.text = [(BVMediaPost *)self.requestToSend requestURL];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"BVResponse";
}

- (void)viewDidUnload
{
    [self setUrlResultsView:nil];
    [self setUrlTextView:nil];
    [super viewDidUnload];
}

// format dictionary as JSON with indents and line breaks.
-(NSString*)prettyJson:(NSDictionary*)json {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.responseToDisplay
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (jsonData == nil) {
        return [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
