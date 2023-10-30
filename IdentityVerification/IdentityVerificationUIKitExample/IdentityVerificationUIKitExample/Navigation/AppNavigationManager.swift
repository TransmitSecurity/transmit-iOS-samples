//
//  AppNavigationManager.swift
//  IdentityVerificationUIKitExample
//
//  Created by Tomer Picker on 25/06/2023.
//

import UIKit

final class AppNavigationManager {
    
    class func initiateViewControllerWith(identifier: VCNames, storyboardName: StoryboardNames) -> UIViewController{
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        return vc
    }
}

enum VCNames: String {
    case VerificationProcessViewController, LoaderViewController
}

enum StoryboardNames: String {
    case Main
}
