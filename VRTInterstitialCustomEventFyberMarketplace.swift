
import IASDKCore
import VrtcalSDK

//Fyber Marketplace Interstitial Adapter, Vrtcal as Primary

class VRTInterstitialCustomEventFyberMarketplace: VRTAbstractInterstitialCustomEvent {
    private var iaAdSpot: IAAdSpot?
    private var iaFullscreenUnitController: IAFullscreenUnitController?
    private var iaVideoContentController: IAVideoContentController?
    private var iaMraidContentController: IAMRAIDContentController?
    
    private var iaUnitDelegatePassthrough = IAUnitDelegatePassthrough()
    private var iaVideoContentDelegatePassthrough = IAVideoContentDelegatePassthrough()
    private var iaMRAIDContentDelegatePassthrough = IAMRAIDContentDelegatePassthrough()
    
    override func loadInterstitialAd() {
        
        VRTLogInfo()
        
        
        guard let spotId = customEventConfig.thirdPartyAdUnitId(
            customEventLoadDelegate: customEventLoadDelegate
        ) else {
            return
        }
        
        // Set Delegates
        iaUnitDelegatePassthrough.viewControllerDelegate = viewControllerDelegate
        iaMRAIDContentDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        
        guard let iaAdRequest = IAAdRequest.build({ builder in
            builder.spotID = spotId
            builder.timeout = 10
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make iaAdRequest"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // videoContentController
        guard let videoContentController = IAVideoContentController.build({ builder in
            builder.videoContentDelegate = self.iaVideoContentDelegatePassthrough
        }) else {
            
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make iaViewUnitController"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // mraidContentController
        guard let mraidContentController = IAMRAIDContentController.build({ builder in
            builder.mraidContentDelegate = self.iaMRAIDContentDelegatePassthrough
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make mraidContentController"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // iaFullscreenUnitController
        guard let iaFullscreenUnitController = IAFullscreenUnitController.build({ builder in
            builder.unitDelegate = self.iaUnitDelegatePassthrough
            builder.addSupportedContentController(mraidContentController)
            builder.addSupportedContentController(videoContentController)
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make iaFullscreenUnitController"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        self.iaFullscreenUnitController = iaFullscreenUnitController
        
        // iaAdSpot
        guard let iaAdSpot = IAAdSpot.build({ builder in
            builder.adRequest = iaAdRequest // pass here the ad request object;
            // all the supported (by a client side) unit controllers,
            // (in this case - view unit controller) should be added to the desired ad spot:
            builder.addSupportedUnitController(iaFullscreenUnitController)
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make iaAdSpot"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // fetchAd
        iaAdSpot.fetchAd() { adSpot, adModel, error in
            if let error {
                VRTLogInfo()
                let vrtError = VRTError(
                    vrtErrorCode: .customEvent,
                    error: error
                )
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
                return
            }
            
            VRTLogInfo()
            self.customEventLoadDelegate?.customEventLoaded()
        }
    }
    
    override func showInterstitialAd() {
        VRTLogInfo()
        iaFullscreenUnitController?.showAd(animated: true) {
            VRTLogInfo()
        }
    }
}
    
    






/*
IAMRAIDContentDelegate, IAVideoContentDelegate {



    func iaAdDidReceiveClick(_ unitController: IAUnitController?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    func iaAdWillLogImpression(_ unitController: IAUnitController?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventShown()
    }

    ///  The rewarded units callback for a user reward.
    ///
    ///  - Remark: This callback is called for all type of the rewarded content, both HTML/JS and video (VAST).
    ///  In order to use the rewarded callback for all available rewarded content, you will have to implement this method (not the `IAVideoCompleted:`;
    func iaAdDidReward(_ unitController: IAUnitController?) {
        VRTLogInfo()
    }

    func iaUnitControllerWillPresentFullscreen(_ unitController: IAUnitController?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillPresentModal(.unknown)
    }

    func iaUnitControllerDidPresentFullscreen(_ unitController: IAUnitController?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.unknown)
    }

    func iaUnitControllerWillDismissFullscreen(_ unitController: IAUnitController?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillDismissModal(.unknown)
    }

    func iaUnitControllerDidDismissFullscreen(_ unitController: IAUnitController?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.unknown)
    }

    func iaUnitControllerWillOpenExternalApp(_ unitController: IAUnitController?) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillLeaveApplication()
    }

    func iaAdDidExpire(_ unitController: IAUnitController?) {
        VRTLogInfo()
    }

    func iaVideoCompleted(_ contentController: IAVideoContentController?) {
        VRTLogInfo()
    }

    func iaVideoContentController(_ contentController: IAVideoContentController?, videoInterruptedWithError error: Error) {
        VRTLogInfo()
    }

    ///  Use to get video duration in seconds. Is valid only if the ad is video ad.
    ///
    ///  - Remark: This method will be invoked after a new received video will become ready to play.
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoDurationUpdated videoDuration: TimeInterval) {
        VRTLogInfo()
    }

    ///  Video progress observer. Use to observe current video progress. Is valid only if the ad is video ad and the video is being played.
    ///
    ///  - Remark: The callback is invoked on the main thread.
    ///
    ///  - Parameters:
    ///   - currentTime: Current playback time in seconds.
    ///    - totalTime:   Total video duration in seconds.
    func iaVideoContentController(_ contentController: IAVideoContentController?, videoProgressUpdatedWithCurrentTime currentTime: TimeInterval, totalTime: TimeInterval) {
        VRTLogInfo()
    }
}


*/
