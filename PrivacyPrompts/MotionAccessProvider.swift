/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the APIs to request access to motion information.
 */

import Foundation
import CoreMotion

class MotionAccessProvider {
    let motionManager = CMMotionActivityManager()
    let activityQueue = OperationQueue()
}

extension MotionAccessProvider: PrivateDataAccessRequestProvider {
    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        motionManager.startActivityUpdates(to: activityQueue) { (_) in
            // Do Something with the activity reported.
            self.motionManager.stopActivityUpdates()

            DispatchQueue.main.async {
                completionHandler(PrivateDataRequestAccessResult(.granted))
            }
        }
    }
}
