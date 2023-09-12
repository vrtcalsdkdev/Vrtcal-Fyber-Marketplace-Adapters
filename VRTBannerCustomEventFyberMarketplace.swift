//  Converted to Swift 5.8.1 by Swiftify v5.8.26605 - https://swiftify.com/
import IASDKCore
import VrtcalSDK

//Fyber Marketplace Banner Adapter, Vrtcal as Primary

class VRTBannerCustomEventFyberMarketplace: VRTAbstractBannerCustomEvent, IAUnitDelegate, IAMRAIDContentDelegate {
    private var adSpot: IAAdSpot?
    private var viewUnitController: IAViewUnitController?
    private var mraidContentController: IAMRAIDContentController?

    func loadBannerAd() {

        VRTLogWhereAmI()

        let spotId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String
        //    NSString *strWidth = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"width"];
        //    NSString *strHeight = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"height"];

        //    CGFloat width = [strWidth respondsToSelector:@selector(floatValue)] ? [strWidth floatValue] : 320;
        //    CGFloat height = [strWidth respondsToSelector:@selector(floatValue)] ? [strHeight floatValue] : 50;

        let userData = IAUserData.build({ builder in
        })

        let adRequest = IAAdRequest.build({ builder in
            builder.userData = userData
            builder.spotID = spotId
            builder.timeout = 10
        })

        mraidContentController = .build({ builder in
            builder.mraidContentDelegate = self
        })

        viewUnitController = IAViewUnitController.build({ [self] builder in
            builder.unitDelegate = self
            // all the needed content controllers should be added to the desired unit controller:
            builder.addSupportedContentController(mraidContentController)
        })

        adSpot = IAAdSpot.build({ [self] builder in
            builder.adRequest = adRequest // pass here the ad request object;
            // all the supported (by a client side) unit controllers,
            // (in this case - view unit controller) should be added to the desired ad spot:
            builder.addSupportedUnitController(viewUnitController)
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

    func getView() -> UIView? {
        return viewUnitController?.adView
    }

    func iaParentViewController(for unitController: IAUnitController?) -> UIViewController {
        VRTLogWhereAmI()
        return viewControllerDelegate.vrtViewControllerForModalPresentation()
    }

    func iamraidContentControllerMRAIDAdWillCollapse(_ contentController: IAMRAIDContentController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventWillDismissModal(VRTModalTypeMraidExpand)
    }

    func iamraidContentControllerMRAIDAdDidCollapse(_ contentController: IAMRAIDContentController?) {
        VRTLogWhereAmI()
        customEventShowDelegate.customEventDidDismissModal(VRTModalTypeMraidExpand)
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
}

//MoPub Banner Adapter, Vrtcal as Primary