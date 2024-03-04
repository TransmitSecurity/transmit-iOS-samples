//
//  AppNavigationManager.swift
//  TOTP-demo-app-samples-iOS
//
//  Created by Tomer Picker on 03/03/2024.
//

import Foundation
import UIKit

final class AppNavigationManager {
    
    class func initiateViewControllerWith(identifier: VCNames, storyboardName: StoryboardNames) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        return vc
    }
}

enum VCNames: String {
    case MainViewController, QRCodeScannerViewController, RegisterTOTPViewController
}

enum StoryboardNames: String {
    case Main
}
