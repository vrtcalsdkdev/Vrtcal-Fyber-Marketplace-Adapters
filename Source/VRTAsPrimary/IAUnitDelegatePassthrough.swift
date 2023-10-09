//
//  Foo.swift
//  Vrtcal-Fyber-Marketplace-Adapters
//
//  Created by Scott McCoy on 9/15/23.
//

import IASDKCore
import VrtcalSDK

class IAUnitDelegatePassthrough: NSObject, IAUnitDelegate {
    
    weak var viewControllerDelegate: ViewControllerDelegate?
    
    func iaParentViewController(for unitController: IAUnitController?) -> UIViewController {
        VRTLogInfo()
        guard let ret = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            VRTLogAlways("ERROR. viewControllerDelegate returned nil!")
            return UIViewController()
        }
        return ret
    }
}
