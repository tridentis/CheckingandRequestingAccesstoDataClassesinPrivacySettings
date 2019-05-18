/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to the music library.
 */

import Foundation
import StoreKit

class MusicAccessProvider: PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let authorizationStatus = SKCloudServiceController.authorizationStatus()
        return authorizationStatus.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        SKCloudServiceController.requestAuthorization { (authorizationStatus) in
            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(authorizationStatus.accessLevel))
            }
        }
    }
}

extension SKCloudServiceAuthorizationStatus: PrivateDataAccessLevelConvertible {
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
