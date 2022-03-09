#import "VRTInterstitialCustomEventFyberMarketplace.h"

#import <IASDKCore/IASDKCore.h>

@interface VRTInterstitialCustomEventFyberMarketplace() <IAUnitDelegate, IAMRAIDContentDelegate, IAVideoContentDelegate>
@property (nonatomic, strong) IAAdSpot *adSpot;
@property (nonatomic, strong) IAFullscreenUnitController *unitController;
@property (nonatomic, strong) IAVideoContentController *videoContentController;
@property (nonatomic, strong) IAMRAIDContentController *mraidContentController;
@end

//Fyber Marketplace Interstitial Adapter, Vrtcal as Primary
@implementation VRTInterstitialCustomEventFyberMarketplace

- (void) loadInterstitialAd {
    
    VRTLogWhereAmI();
    
    NSString *spotId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];

    
    IAUserData *userData = [IAUserData build:^(id<IAUserDataBuilder>  _Nonnull builder) {}];
    
    IAAdRequest *adRequest = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.userData = userData;
        builder.spotID = spotId;
        builder.timeout = 10;
    }];
    
    self.videoContentController = [IAVideoContentController build: ^(id<IAVideoContentControllerBuilder> _Nonnull builder) {
        builder.videoContentDelegate = self;
    }];
    
    self.mraidContentController = [IAMRAIDContentController build: ^(id<IAMRAIDContentControllerBuilder>  _Nonnull builder) {
       builder.MRAIDContentDelegate = self;
    }];

    
    self.unitController = [IAFullscreenUnitController build:^(id<IAFullscreenUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        [builder addSupportedContentController:self.mraidContentController];
        [builder addSupportedContentController:self.videoContentController];
    }];
    
    self.adSpot = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = adRequest; // pass here the ad request object;
        // all the supported (by a client side) unit controllers,
        // (in this case - view unit controller) should be added to the desired ad spot:
        [builder addSupportedUnitController:self.unitController];
    }];

    [self.adSpot fetchAdWithCompletion:^(IAAdSpot * _Nullable adSpot, IAAdModel * _Nullable adModel, NSError * _Nullable error) {
        
        if (error) {
            VRTLogWhereAmI();
            [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
            return;
        }

        VRTLogWhereAmI();
        [self.customEventLoadDelegate customEventLoaded];
    }];
}

-(void) showInterstitialAd {
    VRTLogWhereAmI();
    [self.unitController showAdAnimated:YES completion:^{
        VRTLogWhereAmI();
    }];
}

- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    return [self.viewControllerDelegate vrtViewControllerForModalPresentation];
}




- (void)IAAdDidReceiveClick:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventClicked];
}

- (void)IAAdWillLogImpression:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventShown];
}

/**
 *  @brief The rewarded units callback for a user reward.
 *
 *  @discussion This callback is called for all type of the rewarded content, both HTML/JS and video (VAST).
 *  In order to use the rewarded callback for all available rewarded content, you will have to implement this method (not the `IAVideoCompleted:`;
 */
- (void)IAAdDidReward:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
}

- (void)IAUnitControllerWillPresentFullscreen:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventWillPresentModal:VRTModalTypeUnknown];
}

- (void)IAUnitControllerDidPresentFullscreen:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeUnknown];
}

- (void)IAUnitControllerWillDismissFullscreen:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventWillDismissModal:VRTModalTypeUnknown];
}

- (void)IAUnitControllerDidDismissFullscreen:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeUnknown];
}

- (void)IAUnitControllerWillOpenExternalApp:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventWillLeaveApplication];
}

- (void)IAAdDidExpire:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
}


- (void)IAVideoCompleted:(IAVideoContentController * _Nullable)contentController {
    VRTLogWhereAmI();
}

- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoInterruptedWithError:(NSError * _Nonnull)error {
    VRTLogWhereAmI();
}

/**
 *  @brief Use to get video duration in seconds. Is valid only if the ad is video ad.
 *
 *  @discussion This method will be invoked after a new received video will become ready to play.
 */
- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoDurationUpdated:(NSTimeInterval)videoDuration {
    VRTLogWhereAmI();
}

/**
 *  @brief Video progress observer. Use to observe current video progress. Is valid only if the ad is video ad and the video is being played.
 *
 *  @discussion The callback is invoked on the main thread.
 *
 *  @param currentTime Current playback time in seconds.
 *  @param totalTime   Total video duration in seconds.
 */
- (void)IAVideoContentController:(IAVideoContentController * _Nullable)contentController videoProgressUpdatedWithCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    VRTLogWhereAmI();
}



@end
