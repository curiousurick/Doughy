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
    
    func format(temperature: NSNumber) -> String {
        let tempString = formatter.string(from: temperature)!
        return "\(tempString)º"
    }

}
