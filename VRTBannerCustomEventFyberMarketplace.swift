
import IASDKCore
import VrtcalSDK

// Fyber Marketplace Banner Adapter, Vrtcal as Primary
class VRTBannerCustomEventFyberMarketplace: VRTAbstractBannerCustomEvent {
        
    private var iaAdSpot: IAAdSpot?
    private var iaViewUnitController: IAViewUnitController?
    private var mraidContentController: IAMRAIDContentController?
    
    
    var iaUnitDelegatePassthrough = IAUnitDelegatePassthrough()
    var iaMRAIDContentDelegatePassthrough = IAMRAIDContentDelegatePassthrough()
    
    override func loadBannerAd() {
        
        VRTLogInfo()
        
        guard let spotId = customEventConfig.thirdPartyAdUnitId(
            customEventLoadDelegate: customEventLoadDelegate
        ) else { return }
        
        
        iaUnitDelegatePassthrough.viewControllerDelegate = viewControllerDelegate
        iaMRAIDContentDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        
        
        // Make iaAdRequest
        guard let iaAdRequest = IAAdRequest.build({ builder in
            builder.spotID = spotId
            builder.timeout = 10
        }) else {
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "Could not make iaAdRequest")
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }

        // Make mraidContentController
        guard let mraidContentController = IAMRAIDContentController.build({ builder in
            builder.mraidContentDelegate = self.iaMRAIDContentDelegatePassthrough
        }) else {
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "Could not make mraidContentController")
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // Make iaViewUnitController
        guard let iaViewUnitController = IAViewUnitController.build({ builder in
            builder.unitDelegate = self.iaUnitDelegatePassthrough
            // all the needed content controllers should be added to the desired unit controller:
            builder.addSupportedContentController(mraidContentController)
        }) else {
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "Could not make iaViewUnitController")
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // Make iaAdSpot
        guard let iaAdSpot = IAAdSpot.build({ builder in
            builder.adRequest = iaAdRequest
            builder.addSupportedUnitController(iaViewUnitController)
        }) else {
            let vrtError = VRTError(vrtErrorCode: .customEvent, message: "Could not make iaAdSpot")
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        iaAdSpot.fetchAd() { _, _, nsError in
            
            if let nsError {
                let vrtError = VRTError(vrtErrorCode: .customEvent, error: nsError)
                self.customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
                return
            }
            
            VRTLogInfo()
            self.customEventLoadDelegate?.customEventLoaded()
        }
    }
    
    override func getView() -> UIView? {
        return iaViewUnitController?.adView
    }
}



/*
 , IAMRAIDContentDelegate {

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
}
*/
