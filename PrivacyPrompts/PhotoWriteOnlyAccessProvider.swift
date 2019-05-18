/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates the API to request write only access to photos.
 */

import Foundation
import UIKit

class PhotoWriteOnlyAccessProvider: NSObject, PrivateDataAccessRequestProvider {

    var requestAccessCompletionHandler: PrivacyActionRequestAccessHandler?

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        requestAccessCompletionHandler = completionHandler
        let food = #imageLiteral(resourceName: "Food.jpg")
        UIImageWriteToSavedPhotosAlbum(food, self, #selector(image(_:didFinishSaving:contextInfo:)), nil)
    }

    @objc
    private func image(_ image: UIImage, didFinishSaving error: NSError?, contextInfo: Any?) {
        if let completionHandler = requestAccessCompletionHandler {
            let result = PrivateDataRequestAccessResult(error == nil ? .granted : .denied)
            completionHandler(result)
        }

        // Breaks reference cycle so this object can deinit.
        requestAccessCompletionHandler = nil
    }
}
