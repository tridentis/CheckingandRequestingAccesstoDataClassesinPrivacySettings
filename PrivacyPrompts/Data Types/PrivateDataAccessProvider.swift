/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Configures the check and request actions for specific private data types.
 */

import UIKit

/**
`PrivateDataAccessProvider` defines an interface for checking the current access level
 and requesting access to a user's private data, and regardless of the data type.
 */
typealias PrivateDataAccessProvider = PrivateDataAccessStatusProvider & PrivateDataAccessRequestProvider

/**
`PrivateDataAccessStatusProvider` defines an interface for checking the current access level to a user's private data,
 regardless of the data type.
 */
protocol PrivateDataAccessStatusProvider {
    var accessLevel: PrivateDataAccessLevel { get }
}

/**
 `PrivateDataAccessRequestProvider` defines an interface for requesting access to a user's private data, regardless of the data type.
 */
protocol PrivateDataAccessRequestProvider {
    /// A typealias describing the completion handler used when requesting access to private data.
    typealias PrivacyActionRequestAccessHandler = (_ result: PrivateDataRequestAccessResult) -> Void

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void)
}

/**
 `PrivateDataAccessActions` contains actions for checking and requesting access to a user's private data.
 */
struct PrivateDataAccessActions {
    let dataType: PrivacyDataType
    var accessStatusAction: PrivateDataAccessStatusProvider?
    var requestAccessAction: PrivateDataAccessRequestProvider?

    init(for type: PrivacyDataType) {
        var selectedActions: AnyObject? = nil
        dataType = type

        switch type {
        case .advertising:
            selectedActions = AdvertisingAccessProvider()
        case .appleMusic:
            selectedActions = MusicAccessProvider()
        case .bluetooth:
            selectedActions = BluetoothAccessProvider()
        case .camera:
            selectedActions = CameraAccessProvider()
        case .calendars:
            selectedActions = EventKitAccessProvider(type: .event)
        case .contacts:
            selectedActions = ContactsAccessProvider()
        case .faceID:
            selectedActions = FaceIDAccessProvider()
        case .health:
            selectedActions = HealthAccessProvider()
        case .home:
            selectedActions = HomeAccessProvider()
        case .location:
            selectedActions = LocationAccessProvider()
        case .microphone:
            selectedActions = MicrophoneAccessProvider()
        case .motion:
            selectedActions = MotionAccessProvider()
        case .nfc:
            selectedActions = NFCAccessProvider()
        case .photosLibrary:
            selectedActions = PhotoAccessProvider()
        case .photosLibraryWriteOnly:
            selectedActions = PhotoWriteOnlyAccessProvider()
        case .reminders:
            selectedActions = EventKitAccessProvider(type: .reminder)
        case .siri:
            selectedActions = SiriAccessProvider()
        case .speechRecognition:
            selectedActions = SpeechRecognitionAccessProvider()
        }

        accessStatusAction = selectedActions as? PrivateDataAccessStatusProvider
        requestAccessAction = selectedActions as? PrivateDataAccessRequestProvider
    }
}
