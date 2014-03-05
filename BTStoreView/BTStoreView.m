//
//  BTStoreView.m
//
//  Version 1.2
//
//  Created by Borut Tomazin on 8/30/2013.
//  Copyright 2013 Borut Tomazin
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/borut-t/BTStoreView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "BTStoreView.h"
#import <StoreKit/StoreKit.h>

NSString *const AppStoreUrl = @"itms-apps://itunes.apple.com/us/app/id%ld?mt=8";

@interface BTStoreView ()

@end

@implementation BTStoreView

+ (instancetype)sharedInstance
{
    static BTStoreView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.shouldDiscardCustomTintColor = YES;
}

- (void)openAppStorePageForAppId:(NSInteger)appId
{
    if ([SKStoreProductViewController class]) {
        SKStoreProductViewController *storeProductViewController = [SKStoreProductViewController new];
        storeProductViewController.delegate = (id<SKStoreProductViewControllerDelegate>)self;
        
        if (self.shouldDiscardCustomTintColor) {
            [storeProductViewController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [storeProductViewController.navigationController.navigationBar setTintColor:nil];
        }
        
        //load product details
        NSDictionary *productParameters = @{SKStoreProductParameterITunesItemIdentifier:@(appId).description};
        [storeProductViewController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                UIViewController *rootViewController = nil;
                id appDelegate = [[UIApplication sharedApplication] delegate];
                
                if ([appDelegate respondsToSelector:@selector(viewControllers)]) {
                    rootViewController = [appDelegate viewControllers][0];
                }
                if (!rootViewController && [appDelegate respondsToSelector:@selector(window)]) {
                    rootViewController = [(UIWindow *)[appDelegate valueForKey:@"window"] rootViewController];
                }
                if (!rootViewController) {
                    rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                }
                if (!rootViewController) {
                    NSLog(@"BTStoreView: Failed to present within app. Fallback to the App Store app.");
                    if ([self.delegate respondsToSelector:@selector(BTStoreViewFailedToPresentWithinApp)]) {
                        [self.delegate BTStoreViewFailedToPresentWithinApp];
                    }
                }
                else {
                    while (rootViewController.presentedViewController) {
                        rootViewController = rootViewController.presentedViewController;
                    }
                    
                    [rootViewController presentViewController:storeProductViewController animated:YES completion:nil];
                    [self didAppear];
                    return;
                }
            }
            else {
                NSLog(@"BTStoreView: Failed to present within app: '%@'. Fallback to the App Store app.",error.localizedDescription);
            }
            
            [self showAppStoreAppID:appId];
        }];
    }
    else {
        [self showAppStoreAppID:appId];
    }
}

- (void)showAppStoreAppID:(NSInteger)appId
{
    // Fallback: Open app in AppStore via direct url
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:AppStoreUrl, (long)appId]]]) {
        NSLog(@"BTStoreView: Failed to open in an App Store app.");
        if ([self.delegate respondsToSelector:@selector(BTStoreViewFailedToOpenInAppStore)]) {
            [self.delegate BTStoreViewFailedToOpenInAppStore];
        }
        return;
    }
    
    [self didAppear];
}

- (void)didAppear
{
    if ([self.delegate respondsToSelector:@selector(BTStoreViewDidAppear)]) {
        [self.delegate BTStoreViewDidAppear];
    }
}


#pragma mark - SKStoreProduct Delegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)controller
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    if ([self.delegate respondsToSelector:@selector(BTStoreViewDidDismiss)]) {
        [self.delegate BTStoreViewDidDismiss];
    }
}

@end
