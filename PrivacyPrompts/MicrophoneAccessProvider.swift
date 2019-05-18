/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to the microphone.
 */

import Foundation
import AVFoundation

class MicrophoneAccessProvider: NSObject {
    let audioSession = AVAudioSession.sharedInstance()
}

extension MicrophoneAccessProvider: PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        return audioSession.recordPermission().accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        audioSession.requestRecordPermission { (granted) in
            if granted {
                // Setting the category will also request access from the user.
                do {
                    try self.audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    // Do something with the audio session.
                } catch let error {
                    debugPrint(error)
                }
            } else {
                // Handle denied access gracefully.
            }

            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(self.accessLevel))
            }
        }
    }
}

extension AVAudioSessionRecordPermission: PrivateDataAccessLevelConvertible {
    var accessLevel: PrivateDataAccessLevel {
        switch self {
        case .denied:
            return .denied
        case .undetermined:
            return .undetermined
        case .granted:
            return .granted
        }
    }
}
