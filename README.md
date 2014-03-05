## Purpose
Native App Store window inside app.


##Preview
![iPhone portrait](https://github.com/borut-t/BTStoreView/raw/master/Screenshots/preview.png)


## ARC Support
BTStoreView fully supports ARC.


## Supported OS
iOS 5+


## Installation
Add `pod ‘BTStoreView’` to your Podfile or drag class files (BTStoreView.{h,m}) into your project.


## Notice
Presenting StoreKit when running app in simulator is not possible since iOS 7+.


## Methods
	+ (instancetype)sharedInstance;

BTStoreView singleton method.

	- (void)openAppStorePageForAppId:(NSInteger)appId;

Opens App Store page for passed appId.


## Properties
	@property (nonatomic, weak) id<BTStoreViewDelegate> delegate;

BTStoreView Delegate object.

	@property (nonatomic, assign) BOOL shouldDiscardCustomTintColor;

Resets [UINavigationBar appearance] protocol property barTintColor to system default value. (default YES).


## Delegate methods
	- (void)BTStoreViewDidAppear;

Delegate method when BTStoreView is presented.

	- (void)BTStoreViewDidDismiss;

Delegate method when BTStoreView is dismissed.

	- (void)BTStoreViewFailedToPresentWithinApp;

Delegate method when BTStoreView failed to open App Store inside app.

	- (void)BTStoreViewFailedToOpenInAppStore;

Delegate method when BTStoreView failed to open in an App Store app.