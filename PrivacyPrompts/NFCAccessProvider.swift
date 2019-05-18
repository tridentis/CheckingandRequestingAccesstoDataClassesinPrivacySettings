/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates API to requuest access to read NFC tags.
 */

import Foundation
import CoreNFC

class NFCAccessProvider: NSObject, PrivateDataAccessRequestProvider {

    var readerSession: NFCNDEFReaderSession?
    var requestAccessCompletionHandler: PrivacyActionRequestAccessHandler?

    func requestAccess(completionHandler: @escaping (PrivateDataRequestAccessResult) -> Void) {
        if NFCNDEFReaderSession.readingAvailable {
            requestAccessCompletionHandler = completionHandler

            /*
             Starting a NFC reader session will prompt the user with UI to scan a NFC tag.
             NFC reader access does not have an explicit authorization prompt, but still
             requires NFCReaderUsageDescription to be declared in the Info.plist file.
             If this string is not declared, the app will exit upon starting a NFC session.
            */
            readerSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            readerSession?.begin()
        } else {
            // NFC is not available on all iOS devices.
            completionHandler(PrivateDataRequestAccessResult(.unavailable))
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

extension NFCAccessProvider: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        let result = PrivateDataRequestAccessResult(.unavailable,
                                                    error: error as NSError,
                                                    errorMessageKey: "NFC_SESSION_INVALIDATED_ERROR")
        dispatchAccessResult(result)
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        dispatchAccessResult(PrivateDataRequestAccessResult(.granted))
    }
}
