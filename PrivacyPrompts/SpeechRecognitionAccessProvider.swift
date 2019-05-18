/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to speech recognition.
 */

import Foundation
import Speech

class SpeechRecognitionAccessProvider: PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let authorizationStatus = SFSpeechRecognizer.authorizationStatus()
        return authorizationStatus.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        SFSpeechRecognizer.requestAuthorization { (authorizationStatus) in
            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(authorizationStatus.accessLevel))
            }
        }
    }
}

extension SFSpeechRecognizerAuthorizationStatus: PrivateDataAccessLevelConvertible {
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
