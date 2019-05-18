/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to Siri.
 */

import Foundation
import Intents

class SiriAccessProvider: PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let authorizationStatus = INPreferences.siriAuthorizationStatus()
        return authorizationStatus.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        INPreferences.requestSiriAuthorization { (authorizationStatus) in
            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(authorizationStatus.accessLevel))
            }
        }
    }
}

extension INSiriAuthorizationStatus: PrivateDataAccessLevelConvertible {
    var accessLevel: PrivateDataAccessLevel {
        switch self {
        case .authorized:
            return .granted
        case .denied:
            return .denied
        case .notDetermined:
            return .undetermined
        case .restricted:
            return .restricted
        }
    }
}
