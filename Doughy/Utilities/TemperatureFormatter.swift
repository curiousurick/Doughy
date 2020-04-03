//
//  PercentFormatter.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class TemperatureFormatter: NSObject {
    
    private let formatter = NumberFormatter()
    
    static let shared = TemperatureFormatter()
    
    private override init() {
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
    }
    
    func format(temperature: Temperature) -> String {
        let tempNumber = NSNumber(floatLiteral: temperature.value)
        let tempString = formatter.string(from: tempNumber)!
        return "\(tempString)º \(temperature.measurement.shortValue)"
    }

}
