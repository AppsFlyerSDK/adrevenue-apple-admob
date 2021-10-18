//
//  ViewController.m
//  adRevenueTest
//
//  Created by Amit Kremer on 25/08/2021.
//

#import "ViewController.h"
@import AppsFlyerAdRevenueAdMob;
@import GoogleMobileAds;

@interface ViewController ()

@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitialAd *interstitialView;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@property(nonatomic, strong) GADNativeAd *nativeAd;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// Banner view
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:GADAdSizeBanner];
    [self addBannerViewToView:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-8123415297019784/1423232469";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    [AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:self.bannerView adUnitId:@"ca-app-pub-8123415297019784/1423232469" eventHandler:^(GADAdValue * _Nonnull value) {
        NSLog(@"~~>> Banner");
    }];
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:bannerView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.bottomLayoutGuide
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:bannerView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1
                                      constant:0]
    ]];
}

@end
