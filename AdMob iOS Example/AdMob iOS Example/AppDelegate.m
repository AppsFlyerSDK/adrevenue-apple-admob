//
//  AppDelegate.m
//  adRevenueTest
//
//  Created by Amit Kremer on 25/08/2021.
//

#import "AppDelegate.h"
#import <AppsFlyerAdRevenue/AppsFlyerAdRevenue.h>
@import AppsFlyerAdRevenueAdMob;
#import <AppsFlyerLib/AppsFlyerLib.h>
@import AppTrackingTransparency;

@interface AppDelegate () <AppsFlyerLibDelegate>

@end

@implementation AppDelegate {
    /// The app open ad.
    GADAppOpenAd *_appOpenAd;
    /// Keeps track of is an app open ad loading.
    BOOL _isLoadingAd;
    /// Keeps track of is an app open ad showing.
    BOOL _isShowingAd;
    /// Keeps track of the time an app open ad is loaded to ensure you don't show an expired ad.
    NSDate *_loadTime;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        NSLog(@"sss");
    }];
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"408afbfxXxXxXxa89794a7" ];
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"Us4GxXxXxXx6Qed"];
    [[AppsFlyerLib shared] setAppleAppID:@"741993991"];
    [[AppsFlyerLib shared] setIsDebug:YES];
    [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:5];
    [[AppsFlyerLib shared] start];
    [AppsFlyerAdRevenue start];
    [AppsFlyerAdRevenue shared].isDebug = YES;
    
    return YES;
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    UIWindow *keyWindow = application.keyWindow;
    if (keyWindow) {
        [self showAdIfAvailable:keyWindow.rootViewController];
    }
}

- (void)loadAd {
    // Do not load ad if there is an unused ad or one is already loading.
    if (_isLoadingAd || [self isAdAvailable]) {
        return;
    }
    _isLoadingAd = YES;
    NSLog(@"Start loading ad.");
    [GADAppOpenAd loadWithAdUnitID:@"ca-app-pub-8123415297019784/1490665166"
                           request:[GADRequest request]
                       orientation:UIInterfaceOrientationPortrait
                 completionHandler:^(GADAppOpenAd * _Nullable appOpenAd, NSError * _Nullable error) {
        self->_isLoadingAd = NO;
        if (error) {
            NSLog(@"App open ad failed to load with error: %@.", error);
            return;
        }
        self->_appOpenAd = appOpenAd;
        self->_appOpenAd.fullScreenContentDelegate = self;
        
        [AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:self->_appOpenAd adUnitId:@"ca-app-pub-8123415297019784/1490665166" eventHandler:^(GADAdValue * _Nonnull value) {
            NSLog(@"~~>> App Open Add");
        }];
        
        self->_loadTime = [NSDate date];
        NSLog(@"Loading Succeeded.");
    }];
}

- (BOOL)wasLoadTimeLessThanNHoursAgo:(int)n {
    // Check if ad was loaded more than n hours ago.
    NSDate *now = [NSDate date];
    NSTimeInterval timeIntervalBetweenNowAndLoadTime = [now timeIntervalSinceDate:_loadTime];
    double secondsPerHour = 3600.0;
    double intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour;
    return intervalInHours < n;
}

- (BOOL)isAdAvailable {
    // Check if ad exists and can be shown.
    // Ad references in the app open beta will time out after four hours, but this time limit
    // may change in future beta versions. For details, see:
    // https://support.google.com/admob/answer/9341964?hl=en
    return _appOpenAd && [self wasLoadTimeLessThanNHoursAgo:4];
}

- (void)showAdIfAvailable:(nonnull UIViewController*)viewController {
    // If the app open ad is already showing, do not show the ad again.
    if (_isShowingAd) {
        NSLog(@"The app open ad is already showing.");
        return;
    }
    // If the app open ad is not available yet, invoke the callback then load the ad.
    if (![self isAdAvailable]) {
        NSLog(@"The app open ad is not ready yet.");
        [self loadAd];
        return;
    }
    NSLog(@"Will show ad.");
    _isShowingAd = YES;
    [_appOpenAd presentFromRootViewController:viewController];
}

#pragma mark - GADFullScreenContentDelegate

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"App open ad presented.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    _appOpenAd = nil;
    _isShowingAd = NO;
    NSLog(@"App open ad dismissed.");
    [self loadAd];
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    _appOpenAd = nil;
    _isShowingAd = NO;
    NSLog(@"App open ad failed to present with error: %@.", error.localizedDescription);
    [self loadAd];
}


- (void)onConversionDataFail:(nonnull NSError *)error {
    NSLog(@"~+~+~>> %@", error);
}

- (void)onConversionDataSuccess:(nonnull NSDictionary *)conversionInfo {
    NSLog(@"~+~+~>> %@", conversionInfo);
}

@end
