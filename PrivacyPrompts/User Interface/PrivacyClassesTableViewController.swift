/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Tableview controller that displays all the privacy data classes in the system.
 */

import UIKit

class PrivacyClassesTableViewController: UITableViewController {

    let serviceTypes: [PrivacyDataType] = [
        .advertising,
        .appleMusic,
        .bluetooth,
        .calendars,
        .camera,
        .contacts,
        .faceID,
        .health,
        .home,
        .location,
        .microphone,
        .motion,
        .nfc,
        .photosLibrary,
        .photosLibraryWriteOnly,
        .reminders,
        .siri,
        .speechRecognition
    ]

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "takeAction" {
            if let destinationController = segue.destination as? PrivacyActionsViewController, let row = self.tableView.indexPathForSelectedRow?.row {
                let selectedService = serviceTypes[row]
                destinationController.actions = PrivateDataAccessActions(for: selectedService)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension PrivacyClassesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "privacyClassCell", for: indexPath)
        cell.textLabel?.text = serviceTypes[indexPath.row].localizedValue()

        return cell
    }
}
