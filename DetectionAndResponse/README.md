# Detection and Response

This Transmit iOS sample apps (UIKit & SwiftUI) demonstrates how to use Detect and Response service in your iOS app.
You can read more about Transmit's Detect and Response [here](https://developer.transmitsecurity.com/guides/risk/overview/).

## Prerequisites

To integrate with Transmit Security, you'll need to obtain your client credentials from the [Admin Portal](https://portal.transmitsecurity.io/login/email). From Risk > Settings, you can obtain your client ID and client secret. These will be used to identify your app and generate authorization for requests to Transmit.

## Instructions

To run the sample on your iOS device:  

1 - Configure your client credentials in the `AppDelegate.swift` (`App` for SwiftUI) file and init the SDK:
```bash
TSAccountProtection.initialize(clientId: 'clientId')  # Client ID obtained from the Admin Portal
```

2 - Build and run the application in XCode on your iOS device target.

## Additional Steps

1 - Set user id
```bash
TSAccountProtection.setUserId([USER_ID])
```
2 - Report actions
```bash
 TSAccountProtection.triggerAction([ACTION_TYPE]) { result in
      DispatchQueue.main.async {
          switch result {
          case .success(let response):
              let actionToken: String = response.actionToken
          case .failure(let error):
              switch error {
              case .disabled:
                  break
              case .connectionError:
                  break
              case .internalError:
                  break
              case .notSupportedActionError:
                  break
              @unknown default:
                  break
            }
        }
    }
}
```
                

## What is DRS?

Detection and Response services are embedded into web and mobile apps to help enterprises confidently welcome trusted customers and keep the bad people out. Detect risk in customer interactions on digital channels, and enable informed identity and trust decisions across the consumer experience. This is done by seamlessly monitoring user interactions across multiple channels in real-time and executing a dynamic risk engine that continuously assesses risk, challenges risky users, and elevates trust. This is aimed at reducing unauthorized access while keeping a frictionless experience and low false-positive rates.<br><br>

## Author

Transmit Security, https://github.com/TransmitSecurity

## License

This project is licensed under the MIT license. See the LICENSE file for more info.
