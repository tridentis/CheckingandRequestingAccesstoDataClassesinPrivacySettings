/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to location information.
 */

import Foundation
import CoreLocation

class LocationAccessProvider: NSObject {
    lazy var locationManager: CLLocationManager = CLLocationManager()
    var requestAccessCompletionHandler: PrivacyActionRequestAccessHandler?
}

extension LocationAccessProvider : PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        return authorizationStatus.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        requestAccessCompletionHandler = completionHandler
        locationManager.delegate = self

        /*
         Gets user permission to get their location. This sample asks for location
         always to demonstrate how a user may grant an app access to location only
         while the app is in use.

         Most apps only need location information when the app is in use. To request
         location only while the app is in use:
         1. Replace `locationManager.requestAlwaysAuthorization()` with
         `locationManager.requestWhenInUseAuthorization()`
         2. Change the `NSLocationAlwaysAndWhenInUseUsageDescription` key to
         `NSLocationWhenInUseUsageDescription` in the Info.plist file.
         */
        locationManager.requestAlwaysAuthorization()

        /*
         Requests a single location after the user is presented with a consent
         dialog.
         */
        locationManager.startUpdatingLocation()
    }
}

extension LocationAccessProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle the failure...
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Do something with the new location the application just received...
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        /*
         The delegate function will be called when the permission status changes
         the application should then attempt to handle the change appropriately
         by changing the UI or setting up or tearing down data structures.
         */
        guard status != .notDetermined else { return }
        DispatchQueue.main.async {
            guard let completionHandler = self.requestAccessCompletionHandler else { return }
            completionHandler(PrivateDataRequestAccessResult(self.accessLevel))

            // Breaks reference cycle so this object can deinit.
            self.requestAccessCompletionHandler = nil
        }
    }
}

extension CLAuthorizationStatus: PrivateDataAccessLevelConvertible {
    var accessLevel: PrivateDataAccessLevel {
        switch self {
        case .notDetermined:
            return .undetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorizedAlways:
            return .grantedAlways
        case .authorizedWhenInUse:
            return .grantedWhenInUse
        }
    }
}
