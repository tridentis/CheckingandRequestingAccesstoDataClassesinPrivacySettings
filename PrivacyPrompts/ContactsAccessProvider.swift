/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to contacts.
 */

import UIKit
import Contacts

class ContactsAccessProvider {
    let contactStore = CNContactStore()
}

extension ContactsAccessProvider : PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        return authorizationStatus.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        contactStore.requestAccess(for: .contacts) { (_, error) in
            if let error = error {
                print(error)
            }

            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(self.accessLevel))
            }
        }
    }
}

extension CNAuthorizationStatus: PrivateDataAccessLevelConvertible {
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
