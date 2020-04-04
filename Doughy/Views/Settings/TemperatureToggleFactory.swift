//
//  TemperatureToggleFactory.swift
//  Doughy
//
//  Created by urickg on 4/2/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit
import Eureka

class TemperatureToggleFactory: NSObject {
    
    private let settings = Settings.shared
    
    static let shared = TemperatureToggleFactory()
    
    private override init() { }
    
    func create(viewController: UIViewController) -> SegmentedRow<Temperature.Measurement> {
        return SegmentedRow<Temperature.Measurement>() { row in
            row.title  = "Temperature"
            row.options = Temperature.Measurement.allValues()
            row.value = self.settings.preferredTemp()
            row.displayValueFor = { (rowValue: Temperature.Measurement?) in
                return rowValue!.longValue
            }
        }.onChange({ (row) in
            let currentPreference = self.settings.preferredTemp()
            do {
                try self.settings.updateRecipeTemps(original: currentPreference, target: row.value!)
            }
            catch {
                let alert = AlertViewHelper.createErrorAlert(title: "Error", message: "Could not update preferred temperature", completion: nil)
                viewController.present(alert, animated: true, completion: nil)
                return
            }
            self.settings.setPreferredTemp(measurement: row.value!)
        })
    }

}
