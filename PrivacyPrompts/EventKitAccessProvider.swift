/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to calendar events and reminders.
 */

import Foundation
import EventKit

class EventKitAccessProvider {
    let eventStore = EKEventStore()
    let type: EKEntityType

    init(type: EKEntityType) {
        self.type = type
    }
}

extension EventKitAccessProvider: PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let authorizationStatus = EKEventStore.authorizationStatus(for: type)
        return authorizationStatus.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        eventStore.requestAccess(to: type) { (_, error) in
            if let error = error {
                print(error)
            }

            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(self.accessLevel))
            }
        }
    }
}

extension EKAuthorizationStatus: PrivateDataAccessLevelConvertible {
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
