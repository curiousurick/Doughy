//
//  SettingsViewController.swift
//  Doughy
//
//  Created by urickg on 4/2/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka
import MessageUI

class SettingsViewController: FormViewController {
    
    private let settings = Settings.shared
    private let tempToggleFactory = TemperatureToggleFactory.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Toggles") { section in
            section <<< self.tempToggleFactory.create(viewController: self)
        }
        
        form +++ Section("App") { section in
            section <<< LabelRow() { row in
                row.title = "Donate to your local food bank"
                row.value = "Go to feedingamerica.org"
                row.cellStyle = .subtitle
            }.onCellSelection({ (cell, row) in
                UIApplication.shared.open(URL(string: "https://www.feedingamerica.org/find-your-local-foodbank")!, completionHandler: nil)
            }).cellSetup({ (cell, row) in
                cell.textLabel?.textColor = .label
                
            })
            section <<< ButtonRow() { row in
                row.title = "Open Source Libraries"
                row.cellStyle = .value1
            }.onCellSelection({ (cell, row) in
                self.performSegue(withIdentifier: "ShowOpenSourceLibraries", sender: nil)
            }).cellSetup({ (cell, row) in
                cell.textLabel?.textColor = .label
            })
            section <<< ButtonRow() { row in
                row.title = "Feedback or questions?"
                row.cellStyle = .value1
            }.onCellSelection({ (cell, row) in
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.setSubject("Feedback for Doughy")
                    mail.setToRecipients(["curiousurick@icloud.com"])
                    self.present(mail, animated: true, completion: nil)
                }
                else {
                    let alert = AlertViewHelper.createErrorAlert(title: "Sorry, I'm unable to send email right now.", message: "Please email curiousurick@icloud.com if you have feedback or questions", completion: nil)
                    self.present(alert, animated: true, completion: nil)
                }
            }).cellSetup({ (cell, row) in
                cell.textLabel?.textColor = .label
            })
            section <<< LabelRow() { row in
                row.title = "Version"
                row.value = UIApplication.appVersion
            }
        }
        
    }

}

// SelectorRow conforms to PresenterRowType
public final class CustomPushRow: SelectorRow<PushSelectorCell<Bool>>, RowType {

    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
