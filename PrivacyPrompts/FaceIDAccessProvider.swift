/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to request FaceID access from LocalAuthentication.
 */

import Foundation
import LocalAuthentication

class FaceIDAccessProvider: PrivateDataAccessRequestProvider {

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        let authenticationContext = LAContext()
        let reason = NSLocalizedString("FACE_ID_REASON", comment: "Reset password prompt for FaceID")        

        var authenticationError: NSError?
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authenticationError) {

            guard authenticationContext.biometryType == .faceID else {
                DispatchQueue.main.async {
                    let result = PrivateDataRequestAccessResult(.unavailable,
                                                                error:nil,
                                                                errorMessageKey: "LOCAL_AUTHENTICATION_REQUIRES_FACE_ID")
                    completionHandler(result)
                }
                return
            }

            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        let result = PrivateDataRequestAccessResult(.granted)
                        completionHandler(result)
                    }
                } else {
                    DispatchQueue.main.async {
                        let result = PrivateDataRequestAccessResult(.denied,
                                                                    error: evaluateError as NSError?,
                                                                    errorMessageKey: "LOCAL_AUTHENTICATION_ERROR")
                        completionHandler(result)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                let result = PrivateDataRequestAccessResult(.undetermined,
                                                            error: authenticationError,
                                                            errorMessageKey: "LOCAL_AUTHENTICATION_ERROR")
                completionHandler(result)
            }
        }
    }
}
