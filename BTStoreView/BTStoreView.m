//
//  BTStoreView.m
//
//  Version 1.1
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

#define appStoreUrl @"itms-apps://itunes.apple.com/us/app/id%u?mt=8"

@implementation BTStoreView

+ (id)sharedInstance
{
    static BTStoreView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)openAppStorePageForAppId:(NSInteger)appId
{
    if ([SKStoreProductViewController class]) {
        
        //create store view controller
        SKStoreProductViewController *productController = [[SKStoreProductViewController alloc] init];
        productController.delegate = (id<SKStoreProductViewControllerDelegate>)self;
        
        //set this to reset navigationBar background and tint color
        [productController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [productController.navigationController.navigationBar setTintColor:nil];
        
        //load product details
        NSDictionary *productParameters = @{SKStoreProductParameterITunesItemIdentifier:[@(appId) description]};
        [productController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
            
            if (!result) {
                if (error) {
                    NSLog(@"BTStoreView presentation failed: %@", [error localizedDescription]);
                }
                else {
                    NSLog(@"Could not present BTStoreView because of an unknown error!");
                }
                
                return;
            }
        }];
        
        //get root view controller
        UIViewController *rootViewController = nil;
        id appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate respondsToSelector:@selector(viewControllers)]) {
            rootViewController = [appDelegate viewControllers][0];
        }
        if (!rootViewController && [appDelegate respondsToSelector:@selector(window)]) {
            UIWindow *window = [appDelegate valueForKey:@"window"];
            rootViewController = window.rootViewController;
        }
        if (!rootViewController) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            rootViewController = window.rootViewController;
        }
        if (!rootViewController) {
            NSLog(@"BTStoreView could not find root view controller to present store view!");
        }
        else {
            while (rootViewController.presentedViewController) {
                rootViewController = rootViewController.presentedViewController;
            }
            
            [rootViewController presentViewController:productController animated:YES completion:nil];
            return;
        }
    }
    
    // Open app in AppStore via direct url
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:appStoreUrl, appId]]];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)controller
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
