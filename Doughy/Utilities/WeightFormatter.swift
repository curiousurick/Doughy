//
//  WeightFormatter.swift
//  Doughy
//
//  Created by urickg on 3/29/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class WeightFormatter: NSObject {
    
    private let formatter = NumberFormatter()
    
    static let shared = WeightFormatter()
    
    private override init() {
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
    }
    
    func format(weight: NSNumber) -> String {
        if abs(weight.doubleValue) > 100 {
            formatter.maximumFractionDigits = 0
        }
        else if abs(weight.doubleValue) > 10 {
            formatter.maximumFractionDigits = 1
        }
        else {
            formatter.maximumFractionDigits = 2
        }
        return "\(formatter.string(from: weight)!)g"
    }

}
