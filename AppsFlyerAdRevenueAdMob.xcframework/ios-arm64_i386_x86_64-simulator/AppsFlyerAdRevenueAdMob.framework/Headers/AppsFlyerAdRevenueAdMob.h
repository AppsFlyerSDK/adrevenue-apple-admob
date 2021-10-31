//
//  AppsFlyerAdRevenueAdMob.h
//  AppsFlyerAdRevenueAdMob
//
//  Created by Qua5ar on 31.08.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GADAdValue;
@class GADAppOpenAd;
@class GADRewardedAd;
@class GADNativeAd;
@class GADBannerView;
@class GADInterstitialAd;

typedef void (^AdMobEventHandler)(GADAdValue * _Nonnull value);

@interface AppsFlyerAdRevenueAdMob : NSObject

+ (void)setPaidEventHandlerForTarget:(id)target
                            adUnitId:(NSString *)adUnitId
                        eventHandler:(AdMobEventHandler)eventHandler;

@end

NS_ASSUME_NONNULL_END
