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

### Usage
AppsFlyerAdRevenueAdMob provides 1 api that replace the ad's `setPaidEventHandler`. You should use AppsFlyerAdRevenueAdMob api and NOT the ad's api:<br>
```objective-c
+ (void)setPaidEventHandlerForTarget:(id)target
                            adUnitId:(NSString *)adUnitId
                        eventHandler:(AdMobEventHandler)eventHandler;
```
#### Banner
```objective-c
self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeBanner;
//
// ...Banner configurations
//
[AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:self.bannerView adUnitId:@"ca-app-pub-id" eventHandler:^(GADAdValue * _Nonnull value) {
        // do more actions with GADAdValue
}];
```

#### Interstitial ad
```objective-c
// ...Interstitial ad configurations
[AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:interstitialAd adUnitId:@"ca-app-pub-id" eventHandler:^(GADAdValue * _Nonnull value) {
        // do more actions with GADAdValue
}];
```

#### Native ad
```objective-c
- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {

    // <~+~ Use this api inside didReceivedNativeAd delegate ~+~>

    [AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:nativeAd adUnitId:TestAdUnit eventHandler:^(GADAdValue * _Nonnull value) {
        // do more actions with GADAdValue
    }];
// ....
}
```

#### Rewarded ad
```objective-c
// ...Rewarded ad configurations
self.rewardedAd = ad;
[AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:[self rewardedAd] adUnitId:@"ca-app-pub-id" eventHandler:^(GADAdValue * _Nonnull value) {
    // do more actions with GADAdValue       
}];
```

#### App open
```objective-c
// ...App open ad configurations
self->_appOpenAd = appOpenAd;
[AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:self->_appOpenAd adUnitId:@"ca-app-pub-id" eventHandler:^(GADAdValue * _Nonnull value) {
    // do more actions with GADAdValue       
}];
```