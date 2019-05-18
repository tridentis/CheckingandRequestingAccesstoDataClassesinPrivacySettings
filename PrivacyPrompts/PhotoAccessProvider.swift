/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to photos.
 */

import Foundation
import Photos

class PhotoAccessProvider: NSObject, PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        return authorizationStatus.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(authorizationStatus.accessLevel))
            }
        }
    }
}

extension PHAuthorizationStatus: PrivateDataAccessLevelConvertible {
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
