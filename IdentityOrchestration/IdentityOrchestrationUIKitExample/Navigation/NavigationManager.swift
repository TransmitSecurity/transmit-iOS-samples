//
//  NavigationManager.swift
//  IdentityOrchestrationUIKitExample
//
//  Created by Tomer Picker on 18/09/2023.
//

import Foundation
import UIKit

final class NavigationManager {
    
    class func initiateViewControllerWith(identifier: VCNames, storyboardName: StoryboardNames) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        return vc
    }
}

enum VCNames: String {
    case InformationViewController, PhoneFormViewController, OtpFormViewController, JourneyCompleteViewController, KbaViewController, CryptoBindingViewController, LoaderViewController, WaitForTicketViewController, QRScanningViewController
}

enum StoryboardNames: String {
    case Main
}
