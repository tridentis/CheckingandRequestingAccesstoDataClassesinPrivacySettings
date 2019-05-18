/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Abstractions that allow for handling the different privacy APIs in a consistent manner.
 */

import Foundation

/**
 An enumeration of all the types of private data present on an iOS device
 */
enum PrivacyDataType: String, Localizable {

    case advertising = "SERVICE_ADVERTISING"
    case bluetooth = "SERVICE_BLUETOOTH"
    case calendars = "SERVICE_CALENDARS"
    case camera = "SERVICE_CAMERA"
    case contacts = "SERVICE_CONTACTS"
    case faceID = "SERVICE_FACE_ID"
    case health = "SERVICE_HEALTH"
    case home = "SERVICE_HOME"
    case location = "SERVICE_LOCATION"
    case microphone = "SERVICE_MICROPHONE"
    case motion = "SERVICE_MOTION"
    case appleMusic = "SERVICE_APPLE_MUSIC"
    case nfc = "SERVICE_NFC"
    case photosLibrary = "SERVICE_PHOTO_LIBRARY"
    case photosLibraryWriteOnly = "SERVICE_PHOTO_LIBRARY_WRITE_ONLY"
    case reminders = "SERVICE_REMINDERS"
    case siri = "SERVICE_SIRI"
    case speechRecognition = "SERVICE_SPEECH_RECOGNITION"

    func localizedValue() -> String {
        return NSLocalizedString(self.rawValue, comment: "Table View cell label for \(self.rawValue)")
    }
}

/**
 An enumeration of all the different private data access levels. Not every access level is applicable to every `PrivacyDataType`.
 */
enum PrivateDataAccessLevel: String, Localizable {
    case denied = "DENIED"
    case granted = "GRANTED"
    case grantedWhenInUse = "LOCATION_WHEN_IN_USE"
    case grantedAlways = "LOCATION_ALWAYS"
    case restricted = "RESTRICTED"
    case unavailable = "UNAVAILABLE"
    case undetermined = "UNDETERMINED"

    func localizedValue() -> String {
        return NSLocalizedString(self.rawValue, comment: "Access level label for \(self.rawValue)")
    }
}

/**
 A type describing an `PrivateDataAccessLevel` to the user's private data.
 */
protocol PrivateDataAccessLevelConvertible {
    var accessLevel: PrivateDataAccessLevel { get }
}

/**
 A struct containing the results of prompting the user for access to a subset of their private data.
 */
struct PrivateDataRequestAccessResult: Localizable {
    let accessLevel: PrivateDataAccessLevel
    let error: NSError?
    let errorMessageKey: String?

    init(_ accessLevel: PrivateDataAccessLevel, error: NSError? = nil, errorMessageKey: String? = nil) {
        self.accessLevel = accessLevel
        self.error = error
        self.errorMessageKey = errorMessageKey
    }

    func localizedValue() -> String {
        var message = accessLevel.localizedValue()

        if let errorMessageKey = errorMessageKey, let error = error {
            let localizedErrorFormatString = NSLocalizedString(errorMessageKey, comment: "")
            let errorDescription = String(format: localizedErrorFormatString, error.code, error.localizedDescription)
            message += " \(errorDescription)"
        }

        return message
    }
}
