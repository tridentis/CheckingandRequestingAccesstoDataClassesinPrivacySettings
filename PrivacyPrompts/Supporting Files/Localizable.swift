/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A utility for requesting localized strings for the user interface.
 */

import Foundation

/**
 A type with a localized string that is appropiate to display in UI.
 */
protocol Localizable {
    func localizedValue() -> String
}
