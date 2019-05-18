/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller that handles checking and requesting access to the user's private data classes.
 */

import UIKit

class PrivacyActionsViewController: UITableViewController {

    enum CellType: String {
        // String values are the table view cell identifiers
        case checkAccess = "checkAccessCell"
        case requestAccess = "requestAccessCell"
    }

    var actions: PrivateDataAccessActions?
    var currentStatusCell: UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = actions?.dataType.localizedValue()
    }

    private var numberOfRows: Int {
        var rows = 0

        if actions?.accessStatusAction != nil && actions?.requestAccessAction != nil {
            rows = 2
        } else if actions?.accessStatusAction != nil || actions?.requestAccessAction != nil {
            rows = 1
        }

        return rows
    }

    private func cellType(for indexPath: IndexPath) -> CellType {
        if self.numberOfRows == 2 {
            if indexPath.row == 0 {
                return .checkAccess
            }
            if indexPath.row == 1 {
                return .requestAccess
            }
        } else if self.numberOfRows == 1 {
            if actions?.accessStatusAction != nil {
                return .checkAccess
            } else if actions?.requestAccessAction != nil {
                return .requestAccess
            }
        }

        fatalError("Unexpected number of rows in PrivacyActionsViewController")
    }

    private func showAlert(for dataType: PrivacyDataType, accessLevel: PrivateDataAccessLevel) {

        let formatString = NSLocalizedString("ACCESS_LEVEL_DESCRIPTION", comment: "Format string describing access level")
        let displayString = String(format: formatString, dataType.localizedValue(), accessLevel.localizedValue())
        showAlert(displayString)
    }

    private func showAlert(_ message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("REQUEST_STATUS", comment: "Alert title"),
                                                message: message,
                                                preferredStyle: .alert)
        let closeAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert button"), style: .default) { (_) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(closeAlertAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension PrivacyActionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellType = self.cellType(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath)

        return cell
    }
}

// MARK: UITableViewDelegate

extension PrivacyActionsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let actions = actions else { return }

        let cellType = self.cellType(for: indexPath)
        if cellType == .requestAccess {

            if let requestAccessAction = actions.requestAccessAction {

                requestAccessAction.requestAccess { (result) in
                    if result.errorMessageKey != nil && result.error != nil {
                        self.showAlert(result.localizedValue())
                    } else {
                        self.showAlert(for: actions.dataType, accessLevel: result.accessLevel)
                    }
                }
            }
        } else if cellType == .checkAccess {
            if let accessStatusAction = actions.accessStatusAction {
                showAlert(for: actions.dataType, accessLevel: accessStatusAction.accessLevel)
            }
        }
    }
}
