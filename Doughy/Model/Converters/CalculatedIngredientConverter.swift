//
//  CalculatedIngredientConverter.swift
//  Doughy
//
//  Created by urickg on 3/30/20.
//  Copyright © 2020 George Urick. All rights reserved.
//

import UIKit

class CalculatedIngredientConverter: NSObject {
    let objectFactory = ObjectFactory.shared
    
    static let shared = CalculatedIngredientConverter()
    
    private override init() { }
    
    func convertToCoreData(ingredient: CalculatedIngredient) -> XCCalculatedIngredient {
        let coreData = objectFactory.createCalculatedIngredient()
        
        coreData.name = ingredient.name
        coreData.percentage = NSNumber(floatLiteral: ingredient.percentage)
        coreData.totalPercentage = NSNumber(floatLiteral: ingredient.totalPercentage)
        coreData.isFlour = ingredient.isFlour
        if let temperature = ingredient.temperature {
            coreData.temperature = NSNumber(floatLiteral: temperature)
        }
        coreData.weight = NSNumber(floatLiteral: ingredient.weight)
        
        return coreData
    }
    
    func convertToExternal(ingredient: XCCalculatedIngredient) -> CalculatedIngredient {
        let name = ingredient.name!
        let percentage = ingredient.percentage!.doubleValue
        let totalPercentage = ingredient.totalPercentage!.doubleValue
        let isFlour = ingredient.isFlour
        let temperature = ingredient.temperature?.doubleValue
        let weight = ingredient.weight!.doubleValue
        
        return CalculatedIngredient(name: name, isFlour: isFlour, percentage: percentage, totalPercentage: totalPercentage, temperature: temperature, weight: weight)
    }
}
