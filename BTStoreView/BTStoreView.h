//
//  BTStoreView.h
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

#import <Foundation/Foundation.h>

@protocol BTStoreViewDelegate <NSObject>
@optional

/**
 Delegate method when BTStoreView is presented.
 */
- (void)BTStoreViewDidAppear;

/**
 Delegate method when BTStoreView is dismissed.
 */
- (void)BTStoreViewDidDismiss;

/**
 Delegate method when BTStoreView failed to open App Store inside app.
 */
- (void)BTStoreViewFailedToPresentWithinApp;

/**
 Delegate method when BTStoreView failed to open in an App Store app.
 */
- (void)BTStoreViewFailedToOpenInAppStore;

@end


@interface BTStoreView : NSObject

/**
 BTStoreView singleton method.
 */
+ (instancetype)sharedInstance;

/**
 BTStoreView Delegate object.
 */
@property (nonatomic, weak) id<BTStoreViewDelegate> delegate;

/**
 Resets [UINavigationBar appearance] protocol property barTintColor to system default value. (default YES).
 */
@property (nonatomic, assign) BOOL shouldDiscardCustomTintColor;

/**
 Opens App Store page for passed appId.
 @param appId The App Store application ID to look for.
 */
- (void)openAppStorePageForAppId:(NSInteger)appId;

@end
