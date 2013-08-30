//
//  ViewController.m
//  BTStoreViewExample
//
//  Created by Borut Tomažin on 8/30/13.
//  Copyright (c) 2013 Borut Tomažin. All rights reserved.
//

#import "ViewController.h"
#import "BTStoreView.h"

@interface ViewController ()

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



- (void)openAppStore:(id)sender
{
    [[BTStoreView sharedInstance] openAppStorePageForAppId:364709193];
}

@end
