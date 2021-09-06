# adrevenue-apple-admob
### Integration
To integrate AdRevenue-AdMob into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'AppsFlyer-AdRevenue-AdMob'
```

```objective-c
@import AppsFlyerLib;
@import AppsFlyerAdRevenue;
@import AppsFlyerAdRevenueAdMob;

...
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Setup Google Ads
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    // Setup AppsFlyer
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"{dev-key}"];
    [[AppsFlyerLib shared] setAppleAppID:@"{apple-id}"];
    [[AppsFlyerLib shared] setIsDebug:YES];
 
    // Setup AppsFlyerAdRevenue
    [AppsFlyerAdRevenue start];
    [[AppsFlyerAdRevenue shared] setIsDebug:YES];
    //...
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[AppsFlyerLib shared] start];
}

```

In your UIViewController, where you use AdMob add:

```objective-c
@import AppsFlyerAdRevenueAdMob;
```

### Api:
```objective-c
- (void)handleGADAdValue:(GADAdValue *)value WithAppOpenAd:(GADAppOpenAd *)ad adUnitId:(NSString *)adUnitId;
- (void)handleGADAdValue:(GADAdValue *)value WithRewardedAd:(GADRewardedAd *)ad;
- (void)handleGADAdValue:(GADAdValue *)value WithNativeAd:(GADNativeAd *)ad adUnitId:(NSString *)adUnitId;
- (void)handleGADAdValue:(GADAdValue *)value WithBanner:(GADBannerView *)banner;
- (void)handleGADAdValue:(GADAdValue *)value WithInterstitial:(GADInterstitialAd *)ad;
```
### Usage
#### Banner

```objective-c
// ...Banner configurations
[self.bannerView setPaidEventHandler:^(GADAdValue * _Nonnull value) {
    [[AppsFlyerAdRevenueAdMob shared] handleGADAdValue:value WithBanner:bannerAd];
}];
```

#### Interstitial ad
```objective-c
// ...Interstitial ad configurations
[self.interstitial setPaidEventHandler:^(GADAdValue * _Nonnull value) {
    [[AppsFlyerAdRevenueAdMob shared] handleGADAdValue:value WithInterstitial:interstitialAd];
}];
```

#### Native ad
```objective-c
- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {

    // <~+~ Use this api inside didReceivedNativeAd delegate ~+~>

    GADNativeAdView *nativeAdView = self.nativeAdView;
    [nativeAd setPaidEventHandler:^(GADAdValue * _Nonnull value) {
        [[AppsFlyerAdRevenueAdMob shared] handleGADAdValue:value WithNativeAd:nativeAd adUnitId:@"ca-app-pub-adUnitId"];
    }];
    // ....
}
```

#### Rewarded ad
```objective-c
// ...Rewarded ad configurations
[self.rewardedAd setPaidEventHandler:^(GADAdValue * _Nonnull value) {
    [[AppsFlyerAdRevenueAdMob shared] handleGADAdValue:value WithRewardedAd:rewardedAd];
}];
```

#### App open
```objective-c
// ...App open ad configurations
[self.appOpenAd setPaidEventHandler:^(GADAdValue * _Nonnull value) {
    [[AppsFlyerAdRevenueAdMob shared] handleGADAdValue:value WithAppOpenAd:appOpenAd adUnitId:@"ca-app-pub-adUnitId"];
}];
```