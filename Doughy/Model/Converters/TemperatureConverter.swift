//
//  TemperatureConverter.swift
//  Doughy
//
//  Created by urickg on 4/2/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

fileprivate let multiplier = 1.8
fileprivate let additive = 32.0

class TemperatureConverter: NSObject {
    
    static let shared = TemperatureConverter()
    
    private override init() { }
    
    func convert(temperature: Temperature, target: Temperature.Measurement) -> Temperature {
        let source = temperature.measurement
        let value = temperature.value
        let newValue = convert(temperature: value, source: source, target: target)
        return Temperature(value: newValue, measurement: target)
    }
    
    func convert(temperature: Double, source: Temperature.Measurement, target: Temperature.Measurement) -> Double {
        if source == target {
            return temperature
        }
        let targetValue: Double
        if target == .celsius {
            targetValue = (temperature - additive) / multiplier
        }
        else {
            targetValue = (temperature * multiplier) + additive
        }
        return targetValue
    }

}
