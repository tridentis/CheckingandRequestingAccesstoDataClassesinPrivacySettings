/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to health information.
 */

import Foundation
import HealthKit

class HealthAccessProvider {
    let healthStore = HKHealthStore()
}

extension HealthAccessProvider: PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        // Health data is not available on all devices.
        guard HKHealthStore.isHealthDataAvailable() else { return .unavailable }

        if let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) {
            let authorizationStatus = healthStore.authorizationStatus(for: heartRateType)
            return authorizationStatus.accessLevel
        }

        return .undetermined
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        // Health data is not available on all devices.
        guard HKHealthStore.isHealthDataAvailable() else {
            completionHandler(PrivateDataRequestAccessResult(.unavailable))
            return
        }

        if let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) {
            let heartRateTypeSet: Set<HKQuantityType> = [heartRateType]

            //  Requests consent from the user to read and write heart rate data from the health store.
            healthStore.requestAuthorization(toShare: heartRateTypeSet, read: heartRateTypeSet) { (_, error) in
                if let error = error {
                    print(error)
                }

                DispatchQueue.main.async {
                    completionHandler(PrivateDataRequestAccessResult(self.accessLevel))
                }
            }
        }
    }
}

extension HKAuthorizationStatus: PrivateDataAccessLevelConvertible {
    var accessLevel: PrivateDataAccessLevel {
        switch self {
        case .notDetermined:
            return .undetermined
        case .sharingAuthorized:
            return .granted
        case .sharingDenied:
            return .denied
        }
    }
}
