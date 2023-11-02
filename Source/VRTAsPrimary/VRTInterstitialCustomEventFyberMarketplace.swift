
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
        self.iaAdSpot = iaAdSpot
        
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
        iaMRAIDContentDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        iaFullscreenUnitController?.showAd(animated: true) {
            VRTLogInfo()
        }
    }
}
