/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to check and request access to Bluetooth information.
 */

import Foundation
import CoreBluetooth

class BluetoothAccessProvider: NSObject {
    lazy var bluetoothManager: CBCentralManager = CBCentralManager(delegate: self, queue: nil)
    var requestAccessCompletionHandler: PrivacyActionRequestAccessHandler?
}

extension BluetoothAccessProvider : PrivateDataAccessProvider {
    var accessLevel: PrivateDataAccessLevel {
        let state = bluetoothManager.state
        return state.accessLevel
    }

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        requestAccessCompletionHandler = completionHandler

        if accessLevel == .undetermined {
            /*
             The user is presented with a consent dialog when the application requests to start
             scanning for bluetooth devices. The delegate is only called once after starting a scan.
             */
            bluetoothManager.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            dispatchAccessResult(PrivateDataRequestAccessResult(self.accessLevel))
        }
    }

    private func dispatchAccessResult(_ accessResult: PrivateDataRequestAccessResult) {
        DispatchQueue.main.async {
            if let completionHandler = self.requestAccessCompletionHandler {
                completionHandler(accessResult)

                // Breaks reference cycle so this object can deinit.
                self.requestAccessCompletionHandler = nil
            }
        }
    }
}

extension BluetoothAccessProvider : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        /*
         The delegate method will be called when the permission status changes
         the application should then attempt to handle the change appropriately
         by changing UI or setting up or tearing down data structures.
         */
        dispatchAccessResult(PrivateDataRequestAccessResult(self.accessLevel))
    }
}

extension CBManagerState: PrivateDataAccessLevelConvertible {
    var accessLevel: PrivateDataAccessLevel {
        switch self {
        case .unknown:
            return .undetermined
        case .unauthorized:
            return .denied
       default:
            return .granted
        }
    }
}
