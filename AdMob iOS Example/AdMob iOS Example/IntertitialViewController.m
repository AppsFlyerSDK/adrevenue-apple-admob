//
//  IntertitialViewController.m
//  adRevenueTest
//
//  Created by Amit Kremer on 05/09/2021.
//

#import "IntertitialViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
@import AppsFlyerAdRevenueAdMob;

typedef NS_ENUM(NSUInteger, GameState) {
  kGameStateNotStarted = 0,  ///< Game has not started.
  kGameStatePlaying = 1,     ///< Game is playing.
  kGameStatePaused = 2,      ///< Game is paused.
  kGameStateEnded = 3        ///< Game has ended.
};

/// The game length.
static const NSInteger kGameLength = 5;

@interface IntertitialViewController () <GADFullScreenContentDelegate>

/// The game text.
@property(nonatomic, weak) IBOutlet UILabel *gameText;

/// The play again button.
@property(nonatomic, weak) IBOutlet UIButton *playAgainButton;

/// The interstitial ad.
@property(nonatomic, strong) GADInterstitialAd *interstitial;

/// The countdown timer.
@property(nonatomic, strong) NSTimer *timer;

/// The amount of time left in the game.
@property(nonatomic, assign) NSInteger timeLeft;

/// The state of the game.
@property(nonatomic, assign) GameState gameState;

/// The date that the timer was paused.
@property(nonatomic, strong) NSDate *pauseDate;

/// The last fire date before a pause.
@property(nonatomic, strong) NSDate *previousFireDate;

// go back
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;

@end

@implementation IntertitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Pause game when application is backgrounded.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseGame)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    // Resume game when application becomes active.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeGame)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [self startNewGame];
}

#pragma mark Game logic

- (void)startNewGame {
  [self loadInterstitial];

  self.gameState = kGameStatePlaying;
  self.playAgainButton.hidden = YES;
  self.timeLeft = kGameLength;
  [self updateTimeLeft];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                target:self
                                              selector:@selector(decrementTimeLeft:)
                                              userInfo:nil
                                               repeats:YES];
}

- (void)loadInterstitial {
  GADRequest *request = [GADRequest request];
  [GADInterstitialAd
       loadWithAdUnitID:@"ca-app-pub-8123415297019784/1989187534"
                request:request
      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
          NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
          return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
      [AppsFlyerAdRevenueAdMob setPaidEventHandlerForTarget:ad adUnitId:@"ca-app-pub-8123415297019784/1989187534" eventHandler:^(GADAdValue * _Nonnull value) {
          NSLog(@"~~>> interstitial");
      }];
      }];
}

- (void)updateTimeLeft {
  self.gameText.text = [NSString stringWithFormat:@"%ld seconds left!", (long)self.timeLeft];
}

- (void)decrementTimeLeft:(NSTimer *)timer {
  self.timeLeft--;
  [self updateTimeLeft];
  if (self.timeLeft == 0) {
    [self endGame];
  }
}

- (void)pauseGame {
  if (self.gameState != kGameStatePlaying) {
    return;
  }
  self.gameState = kGameStatePaused;

  // Record the relevant pause times.
  self.pauseDate = [NSDate date];
  self.previousFireDate = [self.timer fireDate];

  // Prevent the timer from firing while app is in background.
  [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeGame {
  if (self.gameState != kGameStatePaused) {
    return;
  }
  self.gameState = kGameStatePlaying;

  // Calculate amount of time the app was paused.
  float pauseTime = [self.pauseDate timeIntervalSinceNow] * -1;

  // Set the timer to start firing again.
  [self.timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:self.previousFireDate]];
}

- (void)endGame {
  self.gameState = kGameStateEnded;
  [self.timer invalidate];
  self.timer = nil;
  __weak IntertitialViewController *weakSelf = self;
  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Game Over"
                       message:[NSString
                                   stringWithFormat:@"You lasted %ld seconds", (long)kGameLength]
                preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *alertAction =
      [UIAlertAction actionWithTitle:@"OK"
                               style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *action) {
          IntertitialViewController *strongSelf = weakSelf;
                               if (!strongSelf) {
                                 return;
                               }
                               if (strongSelf.interstitial &&
                                   [strongSelf.interstitial
                                       canPresentFromRootViewController:strongSelf
                                                                  error:nil]) {
                                 [strongSelf.interstitial presentFromRootViewController:strongSelf];
                               } else {
                                 NSLog(@"Ad wasn't ready");
                               }
                               strongSelf.playAgainButton.hidden = NO;
                             }];
  [alert addAction:alertAction];
  [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma GADFullScreeContentDelegate implementation

- (void)adDidPresentFullScreenContent:(id)ad {
  NSLog(@"Ad did present full screen content.");
}

- (void)ad:(id)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
  NSLog(@"Ad failed to present full screen content with error %@.", [error localizedDescription]);
}

- (void)adDidDismissFullScreenContent:(id)ad {
  NSLog(@"Ad did dismiss full screen content.");
}

#pragma Interstitial button actions

- (IBAction)playAgain:(id)sender {
  [self startNewGame];
}




@end
