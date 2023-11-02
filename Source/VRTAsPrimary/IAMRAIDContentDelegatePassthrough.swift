import IASDKCore
import VrtcalSDK


class IAMRAIDContentDelegatePassthrough: NSObject, IAMRAIDContentDelegate {
    weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    
    func iamraidContentControllerMRAIDAdWillCollapse(
        _ contentController: IAMRAIDContentController?
    ) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillDismissModal(.mraidExpand)
    }
    
    func iamraidContentControllerMRAIDAdDidCollapse(
        _ contentController: IAMRAIDContentController?
    ) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.mraidExpand)
    }
    
    func iaAdDidReceiveClick(
        _ unitController: IAUnitController?
    ) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }
    
    func iaAdWillLogImpression(
        _ unitController: IAUnitController?
    ) {
        VRTLogInfo()
        customEventShowDelegate?.customEventShown()
    }
    
    func iamraidContentController(
        _ contentController: IAMRAIDContentController?,
        mraidAdWillResizeToFrame frame: CGRect
    ) {
        VRTLogInfo()
        // No VRT Analog
    }

    ///  MRAID resize.
    ///  - Remark: Is not relevant to Interstitial.
    func iamraidContentController(
        _ contentController: IAMRAIDContentController?,
        mraidAdDidResizeToFrame frame: CGRect
    ) {
        VRTLogInfo()
        // No VRT Analog
    }

    ///  MRAID expand.
    ///  - Remark: Is not relevant to Interstitial.
    func iamraidContentController(
        _ contentController: IAMRAIDContentController?,
        mraidAdWillExpandToFrame frame: CGRect
    ) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillPresentModal(.mraidExpand)
    }

    ///  MRAID expand.
    ///  - Remark: Is not relevant to Interstitial.
    func iamraidContentController(
        _ contentController: IAMRAIDContentController?,
        mraidAdDidExpandToFrame frame: CGRect
    ) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidPresentModal(.mraidExpand)
    }
    
    func iamraidContentController(
        _ contentController: IAMRAIDContentController?,
        videoInterruptedWithError error: Error
    ) {
        
    }
}
