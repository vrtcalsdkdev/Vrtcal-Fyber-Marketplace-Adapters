//
//  IAVideoContentDelegatePassthrough.swift
//  Vrtcal-Fyber-Marketplace-Adapters
//
//  Created by Scott McCoy on 9/15/23.
//

import IASDKCore
import VrtcalSDK


class IAVideoContentDelegatePassthrough: NSObject, IAVideoContentDelegate {
    func iaVideoCompleted(_ contentController: IAVideoContentController?) {
        VRTLogInfo()
    }
    
    func iaVideoContentController(
        _ contentController: IAVideoContentController?,
        videoInterruptedWithError error: Error
    ) {
        VRTLogInfo()
    }
    
    func iaVideoContentController(
        _ contentController: IAVideoContentController?,
        videoDurationUpdated videoDuration: TimeInterval
    ) {
        VRTLogInfo()
    }
    
    func iaVideoContentController(
        _ contentController: IAVideoContentController?,
        videoProgressUpdatedWithCurrentTime currentTime: TimeInterval, totalTime: TimeInterval
    ) {
        VRTLogInfo()
    }
}
