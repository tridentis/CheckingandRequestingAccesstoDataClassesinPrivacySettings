/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to request access to the camera.
 */

import Foundation
import AVFoundation

class CameraAccessProvider: PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        return AVCaptureDevice.authorizationStatus(for: .video).accessLevel
    }
    
    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { (_) in
            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(self.accessLevel))
            }
        }
    }
}

extension AVAuthorizationStatus: PrivateDataAccessLevelConvertible {
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
