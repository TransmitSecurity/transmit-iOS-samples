# Identity Verification

This Transmit iOS sample apps (UIKit & SwiftUI) demonstrates how to use Identity Verification service in your iOS app.
You can read more about Transmit's Identity Verification [here](https://developer.transmitsecurity.com/guides/verify/identity_verification_overview/).

## Prerequisites

To integrate with Transmit, you'll need to configure an application, see more details about it [here](https://developer.transmitsecurity.com/guides/verify/quick_start_ios/). 

## Instructions

To run the sample on your iOS device:  

1 - Configure your client credentials in the `AppDelegate.swift` (`App` for SwiftUI) file and init the SDK:
```bash
TSIdentityVerification.initialize(clientId: 'clientId')  # Client ID obtained from the Admin Portal
```
When your app configuration is based on EU, override the default base url with the appropriate one as part of the initialization process. For example:
 ```bash
 TSIdentityVerification.initialize(baseUrl: "https://api.eu.transmitsecurity.io/verify", clientId: 'clientId') # Client ID obtained from the Admin Portal
```
2 - Build and run the application in XCode on your iOS device target.

## Additional Steps

1 - Set observer to TSIdentityVerification's delegate
```bash
private let idvObserver = IDVStatusObserver()
TSIdentityVerification.delegate = idvObserver
```
2 - Conform to TSIdentityVerificationDelegate, and observe status updates
```bash
private class IDVStatusObserver: TSIdentityVerificationDelegate {
    
    func verificationDidStartCapturing() {
        ...
    }
    
    func verificationDidStartProcessing() {
        ...
    }
    
    func verificationRequiresRecapture(reason: TSRecaptureReason) {
        ...
    }
    
    func verificationDidComplete() {
        ...
    }

    func verificationDidFail(with error: IdentityVerification.TSIdentityVerificationError) {
        ...
    }
}
```
3 - Add camera permission
                

## What is Identity Verification?
Identity verification is the process of verifying that a user is the person they claim to be. In the digital world, this means tying a digital identity with the real-world identity. This typically involves verifying their ID document (like driver's license or passport), comparing a selfie to their photo ID, and various other checks.
You can use identity verification to securely verify the identity of your customers using documents like their driver’s license or passport—such as before allowing them to open a new bank account online or pick up a rental car.<br><br>

## Author

Transmit Security, https://github.com/TransmitSecurity

## License

This project is licensed under the MIT license. See the LICENSE file for more info.
