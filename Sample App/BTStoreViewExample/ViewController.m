//
//  ViewController.m
//  BTStoreViewExample
//
//  Created by Borut Tomažin on 8/30/13.
//  Copyright (c) 2013 Borut Tomažin. All rights reserved.
//

#import "ViewController.h"
#import "BTStoreView.h"

@interface ViewController () <BTStoreViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *button;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIncidator;

- (IBAction)openAppStore:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Custom methods
- (void)openAppStore:(id)sender
{
    self.button.hidden = YES;
    self.loadingIncidator.hidden = NO;
    
    [BTStoreView sharedInstance].delegate = self;
    [[BTStoreView sharedInstance] openAppStorePageForAppId:548265827];
}



#pragma mark - BTStoreView delegate methods
- (void)BTStoreViewDidAppear
{
}

- (void)BTStoreViewDidDismiss
{
    self.button.hidden = NO;
    self.loadingIncidator.hidden = YES;
}

- (void)BTStoreViewFailedToPresentWithinApp
{
    [self BTStoreViewDidDismiss];
}

@end
