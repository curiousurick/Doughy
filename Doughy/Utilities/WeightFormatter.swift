//
//  WeightFormatter.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class WeightFormatter: NSObject {
    
    static let shared = WeightFormatter()
    
    private override init() {
}
    
    func format(weight: Double, minimumFraction: Int = 0) -> String {
        let minFraction = minimumFraction >= 0 ? minimumFraction : 0
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        if abs(weight) > 100 {
            formatter.maximumFractionDigits = 0
        }
        else if abs(weight) > 10 {
            formatter.maximumFractionDigits = 1
        }
        else {
            formatter.maximumFractionDigits = 2
        }
        formatter.minimumFractionDigits = minFraction
        return "\(formatter.string(from: NSNumber(floatLiteral: weight))!)g"
    }
}

extension NumberFormatter {
    func number(from number: NSNumber) -> NSNumber? {
        let stringValue = string(from: number)
        if stringValue == nil { return nil }
        return self.number(from: stringValue!)
    }
    
}
