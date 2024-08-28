
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
        
        VRTAsPrimaryManager.singleton.initializeThirdParty(
            customEventConfig: customEventConfig
        ) { result in
            switch result {
            case .success():
                self.finishLoadingInterstitial()
            case .failure(let vrtError):
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            }
        }
    }
    
    func finishLoadingInterstitial() {
        VRTLogInfo()
        
        guard let spotId = customEventConfig.thirdPartyCustomEventDataValueOrFailToLoad(
            thirdPartyCustomEventKey: .adUnitId,
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
        
        // IAVideoContentController
        guard let iaVideoContentController = IAVideoContentController.build({ builder in
            builder.videoContentDelegate = self.iaVideoContentDelegatePassthrough
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make IAVideoContentController"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        self.iaVideoContentController = iaVideoContentController
        
        // IAMRAIDContentController
        guard let iaMraidContentController = IAMRAIDContentController.build({ builder in
            builder.mraidContentDelegate = self.iaMRAIDContentDelegatePassthrough
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make IAMRAIDContentController"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        self.iaMraidContentController = iaMraidContentController
        
        // IAViewUnitController
        guard let viewUnitController = IAViewUnitController.build({ (builder: IAViewUnitControllerBuilder) in
            builder.unitDelegate = self.iaUnitDelegatePassthrough
            builder.addSupportedContentController(iaMraidContentController)
            builder.addSupportedContentController(iaVideoContentController)
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make IAViewUnitController"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // IAFullscreenUnitController
        guard let iaFullscreenUnitController = IAFullscreenUnitController.build({ builder in
            builder.unitDelegate = self.iaUnitDelegatePassthrough
            builder.addSupportedContentController(iaMraidContentController)
            builder.addSupportedContentController(iaVideoContentController)
        }) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not make IAFullscreenUnitController"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        self.iaFullscreenUnitController = iaFullscreenUnitController
        
        // IAAdSpot
        guard let iaAdSpot = IAAdSpot.build({ builder in
            builder.adRequest = iaAdRequest // pass here the ad request object;
            // all the supported (by a client side) unit controllers,
            // (in this case - view unit controller) should be added to the desired ad spot:
            builder.addSupportedUnitController(iaFullscreenUnitController)
            builder.addSupportedUnitController(viewUnitController)
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
            VRTLogInfo("adSpot: \(String(describing: adSpot)), adModel: \(String(describing: adModel)), error: \(String(describing: error))")
            if let error {
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
