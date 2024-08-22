import IASDKCore
import VrtcalSDK

// Must be NSObject for IAGlobalAdDelegate
class VRTAsPrimaryManager: NSObject {

    static var singleton = VRTAsPrimaryManager()
    var shouldInit = true
    
    func initializeThirdParty(
        customEventConfig: VRTCustomEventConfig,
        completionHandler: @escaping (Result<Void,VRTError>) -> ()
    ) {
        VRTLogInfo()
        guard shouldInit else {
            return
        }
        
        // Require the appId
        guard let appId = customEventConfig.thirdPartyCustomEventDataValue(
            thirdPartyCustomEventKey: .appId
        ).getSuccess(failureHandler: { vrtError in
            completionHandler(.failure(vrtError))
        }) else {
            return
        }
        
        IASDKCore.sharedInstance().globalAdDelegate = self
        IASDKCore.sharedInstance().initWithAppID(
            appId,
            completionBlock: { initialized, error in
                VRTLogInfo("Fyber Marketplace initialized: \(initialized) error: \(String(describing: error))")
                
                if let error {
                    let vrtError = VRTError(customEventError: error)
                    completionHandler(.failure(vrtError))
                    return
                }
                
                if !initialized {
                    let error = VRTError(
                        vrtErrorCode: .customEvent,
                        message: "Fyber Marketplace Not Initialized"
                    )
                    completionHandler(.failure(error))
                    return
                }
                
                self.shouldInit = false
                completionHandler(.success())
                

            },
            completionQueue: nil
        )
    }
}

extension VRTAsPrimaryManager: IAGlobalAdDelegate {
    // At the time of this writing (Aug 22 2024), this is the only function in IAGlobalAdDelegate
    func adDidShow(
        with impressionData: IAImpressionData,
        with adRequest: IAAdRequest
    ) {
        VRTLogInfo()
    }
}
