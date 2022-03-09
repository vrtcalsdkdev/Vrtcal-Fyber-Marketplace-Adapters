#import "VRTBannerCustomEventFyberMarketplace.h"

#import <IASDKCore/IASDKCore.h>

@interface VRTBannerCustomEventFyberMarketplace() <IAUnitDelegate, IAMRAIDContentDelegate>
@property (nonatomic, strong) IAAdSpot *adSpot;
@property (nonatomic, strong) IAViewUnitController*viewUnitController;
@property (nonatomic, strong) IAMRAIDContentController*mraidContentController;
@end

//MoPub Banner Adapter, Vrtcal as Primary
@implementation VRTBannerCustomEventFyberMarketplace

- (void) loadBannerAd {
    
    VRTLogWhereAmI();
    
    NSString *spotId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
//    NSString *strWidth = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"width"];
//    NSString *strHeight = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"height"];
    
//    CGFloat width = [strWidth respondsToSelector:@selector(floatValue)] ? [strWidth floatValue] : 320;
//    CGFloat height = [strWidth respondsToSelector:@selector(floatValue)] ? [strHeight floatValue] : 50;
    
    IAUserData *userData = [IAUserData build:^(id<IAUserDataBuilder>  _Nonnull builder) {}];
    
    IAAdRequest *adRequest = [IAAdRequest build:^(id<IAAdRequestBuilder>  _Nonnull builder) {
        builder.userData = userData;
        builder.spotID = spotId;
        builder.timeout = 10;
    }];
    
    self.mraidContentController = [IAMRAIDContentController build: ^(id<IAMRAIDContentControllerBuilder>  _Nonnull builder) {
       builder.MRAIDContentDelegate = self;
    }];
    
    self.viewUnitController = [IAViewUnitController build:^(id<IAViewUnitControllerBuilder>  _Nonnull builder) {
        builder.unitDelegate = self;
        // all the needed content controllers should be added to the desired unit controller:
        [builder addSupportedContentController:self.mraidContentController];
    }];
    
    self.adSpot = [IAAdSpot build:^(id<IAAdSpotBuilder>  _Nonnull builder) {
        builder.adRequest = adRequest; // pass here the ad request object;
        // all the supported (by a client side) unit controllers,
        // (in this case - view unit controller) should be added to the desired ad spot:
        [builder addSupportedUnitController:self.viewUnitController];
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

- (UIView*) getView {
    return self.viewUnitController.adView;
}


- (UIViewController * _Nonnull)IAParentViewControllerForUnitController:(IAUnitController * _Nullable)unitController {
    VRTLogWhereAmI();
    return [self.viewControllerDelegate vrtViewControllerForModalPresentation];
}


- (void)IAMRAIDContentControllerMRAIDAdWillCollapse:(IAMRAIDContentController * _Nullable)contentController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventWillDismissModal:VRTModalTypeMraidExpand];
}

- (void)IAMRAIDContentControllerMRAIDAdDidCollapse:(IAMRAIDContentController * _Nullable)contentController {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeMraidExpand];
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

@end
