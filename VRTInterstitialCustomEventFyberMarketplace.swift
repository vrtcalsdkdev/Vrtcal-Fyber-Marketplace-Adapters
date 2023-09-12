//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
import IASDKCore
import VrtcalSDK

//Fyber Marketplace Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventFyberMarketplace: VRTAbstractInterstitialCustomEvent, IAUnitDelegate, IAMRAIDContentDelegate, IAVideoContentDelegate {
    private var adSpot: IAAdSpot?
    private var unitController: IAFullscreenUnitController?
    private var videoContentController: IAVideoContentController?
    private var mraidContentController: IAMRAIDContentController?

    func loadInterstitialAd() {

        VRTLogWhereAmI()

        let spotId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String


        let userData = IAUserData.build({ builder in
        })

        let adRequest = IAAdRequest.build({ builder in
            builder.userData = userData
            builder.spotID = spotId
            builder.timeout = 10
        })

        videoContentController = .build({ builder in
            builder.videoContentDelegate = self
        })

        mraidContentController = .build({ builder in
            builder.mraidContentDelegate = self
        })


        unitController = IAFullscreenUnitController.build({ [self] builder in
            builder.unitDelegate = self
            builder.addSupportedContentController(mraidContentController)
            builder.addSupportedContentController(videoContentController)
        })

        adSpot = IAAdSpot.build({ [self] builder in
            builder.adRequest = adRequest // pass here the ad request object;
            // all the supported (by a client side) unit controllers,
            // (in this case - view unit controller) should be added to the desired ad spot:
            builder.addSupportedUnitController(unitController)
        })

        adSpot?.fetchAd() { [self] adSpot, adModel, error in

            if let error {
                VRTLogWhereAmI()
                customEventLoadDelegate.customEventFailedToLoadWithError(error)
                return
            }

            VRTLogWhereAmI()
            customEventLoadDelegate.customEventLoaded()
        }
    }

    func showInterstitialAd() {
        VRTLogWhereAmI()
        unitController?.showAd(animated: true) {
            VRTLogWhereAmI()
        }
    }

    func iaParentViewController(for unitController: IAUnitController?) -> UIViewController {
        VRTLogWhereAmI()
        return viewControllerDelegate.vrtViewControllerForModalPresentation()
    }

    func iaAdDidReceiveClick(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventClicked()
    }

    func iaAdWillLogImpression(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventShown()
    }

    ///  The rewarded units callback for a user reward.
    ///
    ///  - Remark: This callback is called for all type of the rewarded content, both HTML/JS and video (VAST).
    ///  In order to use the rewarded callback for all available rewarded content, you will have to implement this method (not the `IAVideoCompleted:`;
    func iaAdDidReward(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
    }

    func iaUnitControllerWillPresentFullscreen(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventWillPresentModal(VRTModalTypeUnknown)
    }

    func iaUnitControllerDidPresentFullscreen(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidPresentModal(VRTModalTypeUnknown)
    }

    func iaUnitControllerWillDismissFullscreen(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventWillDismissModal(VRTModalTypeUnknown)
    }

    func iaUnitControllerDidDismissFullscreen(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeUnknown)
    }

    func iaUnitControllerWillOpenExternalApp(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventWillLeaveApplication()
    }

    func iaAdDidExpire(_ unitController: IAUnitController?) {
        VRTLogWhereAmI()
    }

    func iaVideoCompleted(_ contentController: IAVideoContentController?) {
        VRTLogWhereAmI()
    }

    func iaVideoContentController(_ contentController: IAVideoContentController?, videoInterruptedWithError error: Error) {
        VRTLogWhereAmI()
    }

    ///  Use to get video duration in seconds. Is valid only if the ad is video ad.
    ///
    ///  - Remark: This method will be invoked after a new received video will become ready to play.
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoDurationUpdated videoDuration: TimeInterval) {
        VRTLogWhereAmI()
    }

    ///  Video progress observer. Use to observe current video progress. Is valid only if the ad is video ad and the video is being played.
    ///
    ///  - Remark: The callback is invoked on the main thread.
    ///
    ///  - Parameters:
    ///   - currentTime: Current playback time in seconds.
    ///    - totalTime:   Total video duration in seconds.
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoProgressUpdatedWithCurrentTime currentTime: TimeInterval, totalTime: TimeInterval) {
        VRTLogWhereAmI()
    }
}

//Fyber Marketplace Interstitial Adapter, Vrtcal as Primary