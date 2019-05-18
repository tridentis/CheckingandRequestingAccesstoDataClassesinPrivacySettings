/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates API to check access to advertising information.
 */

import Foundation
import AdSupport

class AdvertisingAccessProvider: PrivateDataAccessStatusProvider {
    var accessLevel: PrivateDataAccessLevel {
        /*
         It is required to check the value of the property isAdvertisingTrackingEnabled before using the advertising identifier.
         If the value is NO, then identifier can only be used for the purposes enumerated in the program license agreement note
         that the advertising ID can be controlled by restrictions just like the rest of the privacy data classes.
         Applications should not cache the advertising ID as it can be changed via the reset button in Settings.
         */
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? .granted : .denied
    }
}
